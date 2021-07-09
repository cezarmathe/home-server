#!/usr/bin/env bash

for recipient in $@; do
    if [[ -f "${recipient}" ]]; then
        printf "%s" "-R ${recipient} "
    else
        printf "%s" "-r ${recipient} "
    fi
done
