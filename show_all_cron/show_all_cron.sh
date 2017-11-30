#!/bin/bash

# show_all_cron.sh

# Shows crontabs of all users
# Copyright 2017 Felix Wolfsteller GPL3+

for user in $(cut -f1 -d: /etc/passwd); do crontab -u $user -l 2>&1 | grep -v 'no cro\|^#.*' | sed "s/^/\n$user:\n/" ; done

