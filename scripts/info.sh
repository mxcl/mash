#!/usr/bin/env -S pkgx bash -eo pipefail

if [ ! "$1" ]; then
  echo "usage: mash info <program>" 1>&2
  exit 1
fi

if [ "$1" == '--help' ]; then
  echo "usage: mash info <program>"
  exit 0
fi

mapfile -t project < <(pkgx -qQ $1)

if [ "${#project[@]}" -eq 0 ] || [[ "${project[@]}" = *" not found" ]]; then
  echo "unknown program: $1" 1>&2
  exit 1
fi

if [ "${#project[@]}" -gt 1 ]; then
  echo "multiple projects provide: $1" 1>&2
  exit 1
fi

open "https://pkgx.dev/pkgs/${project[0]}/"
