#!/bin/bash

if [ "$REQUEST_METHOD" = "POST" ]; then
    challenge_id="${FORM_DATA[challenge_id]}"
    flag="${FORM_DATA[flag]}"
    submitter="${FORM_DATA[submitter]:-Anonymous}"
    
    if [ -n "$flag" ]; then
        [ ! -f data/flags.txt ] && touch data/flags.txt
        
        timestamp=$(date "+%Y-%m-%d %H:%M:%S")
        
        echo "${challenge_id}|${flag}|${submitter}|${timestamp}" >> data/flags.txt
        
        echo "<div class=\"success\">✓ Flag submitted and saved for team collaboration!</div>"
        
    else
        echo "<div class=\"error\">Please enter a flag or note.</div>"
    fi
else
    echo "<div class=\"error\">Invalid request method.</div>"
fi 