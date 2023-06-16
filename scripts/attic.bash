#!/usr/bin/env bash

set -euf -o pipefail

system="$(nix eval --impure --raw --expr 'builtins.currentSystem')"

attic login default ${ATTIC_URL} ${ATTIC_AUTH_TOKEN}
attic use ${ATTIC_CACHE}

packages=$(nix flake show --json | jq ".packages.\"$system\" | keys | .[]" | tr -d \")
for package in $packages; do
  nix build .#$package
  attic push ${ATTIC_CACHE} ./result
done
