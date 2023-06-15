#!/usr/bin/env bash

set -euf -o pipefail

attic login default ${ATTIC_URL} ${ATTIC_AUTH_TOKEN}
attic use ${ATTIC_CACHE}

packages=$(nix flake show --json | jq '.packages."x86_64-linux" | keys | .[]' | tr -d \")
for package in $packages; do
  nix build .#$package
  attic push ${ATTIC_CACHE} ./result
done
