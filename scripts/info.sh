#!/usr/bin/env -S pkgx bash -eo pipefail

if [ ! "$1" ]; then
  echo "usage: mash info <program>" 1>&2
  echo "usage: mash info <--random|-r>" 1>&2
  exit 1
fi

if [ "$1" = '--help' -o "$1" = '--help' ]; then
  echo "usage: mash info <program>"
  echo "usage: mash info <--random|-r>"
  exit 0
fi

if [ "$1" == '--random' -o "$1" == '-r' ]; then
  set -- "$(pkgx -Q | tr , '\n' | pkgx -q shuf -n1)"
fi

IFS=$',\n' read -r -a project < <(pkgx -Q "$1")

if [ "${#project[@]}" -eq 0 ] || [[ "${project[@]}" = *" not found" ]]; then
  echo "unknown program: $1" 1>&2
  exit 1
fi

if [ "${#project[@]}" -gt 1 ]; then
  echo "multiple projects provide: $1" 1>&2
  exit 1
fi

if [ $(uname) = Darwin ]; then
  open "https://pkgx.dev/pkgs/${project[0]}/"
else
  # TODO pkg this for pkgx
  xdg-open "https://pkgx.dev/pkgs/${project[0]}/"
fi
