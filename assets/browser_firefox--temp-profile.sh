#!/bin/bash

local profile_dir
profile_dir="$(mktemp -p /tmp -d firefox-profile.XXXXXX)"
echo "profile path: $profile_dir"
firefox -profile "$profile_dir" -no-remote -new-instance
rm -rf "$profile_dir"
