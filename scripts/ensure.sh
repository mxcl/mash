#!/usr/bin/env -S pkgx --quiet bash>=4 -eo pipefail

_main() {
  if [ "$1" = "--help" -o -z "$1" ]; then
    echo "brief: ensures that a specified program is available, installing it if necessary"
    echo "usage: mash ensure <program> [<arg>…]"
    echo 'usage: eval "$(mash ensure +<program> [+<program>…])"'
    echo 'usage: eval "$(mash ensure --env <program> [<program>…])"'
    if [ "$1" != "--help" ]; then
      exit 1
    else
      exit 0
    fi
  fi

  _SOME_PLUS=no
  _EVAL=yes

  if [ "$1" = "--env" ]; then
    shift
    _SOME_PLUS=yes
    _NEW_ARGS=()
    for arg in "$@"; do
      if [ "${arg:0:1}" != "+" ]; then
        arg="+$arg"
      fi
      _NEW_ARGS+=("$arg")
    done
    set -- "${_NEW_ARGS[@]}"
  else
    # check if all args begin with a +
    for arg in "$@"; do
      if [ "${arg:0:1}" != "+" ]; then
        _EVAL=no
        break
      else
        _SOME_PLUS=yes
      fi
    done
  fi

  if [ $_EVAL = no -a $_SOME_PLUS = yes ]; then
    echo "ensure: unable to mix plus args with unplussed args" >&2
    exit 1
  fi

  if [ $_EVAL = yes ]; then
    _KEEP=()
    for arg in "$@"; do
      if ! _check_arg ${arg:1}; then
        _KEEP+=("$arg")
      fi
    done
    if [ ${#_KEEP[@]} -gt 0 ]; then
      exec pkgx --quiet "${_KEEP[@]}"
    fi
  elif _check_arg $1; then
    if [ $1 = python -a $(uname) = Darwin ]; then
      shift
      exec python3 "$@"
    else
      exec "$@"
    fi
  else
    exec pkgx --quiet "$@"
  fi
}

_check_arg() {
  if [ $(uname) = Darwin ]; then
    case $1 in
    python)
      test -f /Library/Developer/CommandLineTools/usr/bin/python3
      ;;
    make|python3|cc|c++|gcc|g++|clang|clang++|strip|git)
      test -f /Library/Developer/CommandLineTools/usr/bin/$1
      ;;
    esac
  fi
  command -v $1 >/dev/null 2>&1
}

_main "$@"
