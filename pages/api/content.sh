#!/bin/bash

tab="${QUERY_PARAMS[tab]}"

if [ -z "$tab" ]; then
    tab="challenges"
fi

case "$tab" in
    "challenges")
        exec pages/api/challenges.sh
        ;;
    "tools")
        exec pages/api/tools.sh
        ;;
    "wordlists")
        exec pages/api/wordlists.sh
        ;;
    *)
        exec pages/api/challenges.sh
        ;;
esac 