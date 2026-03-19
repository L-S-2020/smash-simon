#!/bin/sh
printf '\033c\033]0;%s\a' Smash Simon
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Smash Simon.x86_64" "$@"
