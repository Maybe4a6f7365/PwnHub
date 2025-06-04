#!/bin/bash

if [ "$REQUEST_METHOD" = "POST" ]; then
    challenge_id="${FORM_DATA[challenge_id]}"
    notes="${FORM_DATA[notes]}"
    editor="${FORM_DATA[editor]:-Anonymous}"
    
    if [ -n "$challenge_id" ]; then
        [ ! -f data/team-notes.txt ] && touch data/team-notes.txt
        
        grep -v "^${challenge_id}|" data/team-notes.txt > data/team-notes.tmp 2>/dev/null || touch data/team-notes.tmp
        
        if [ -n "$notes" ]; then
            timestamp=$(date "+%Y-%m-%d %H:%M:%S")
            echo "${challenge_id}|${notes}|${editor}|${timestamp}" >> data/team-notes.tmp
        fi
        
        mv data/team-notes.tmp data/team-notes.txt
        
        echo '<div class="success">✓ Notes saved successfully</div>'
    else
        echo '<div class="error">Missing challenge ID</div>'
    fi
    
elif [ "$REQUEST_METHOD" = "GET" ]; then
    challenge_id="${QUERY_PARAMS[challenge_id]}"
    
    if [ -n "$challenge_id" ] && [ -f data/team-notes.txt ]; then
        while IFS='|' read -r note_challenge_id notes editor timestamp; do
            [ -z "$note_challenge_id" ] && continue
            if [ "$note_challenge_id" = "$challenge_id" ]; then
                echo "$notes"
                exit 0
            fi
        done < data/team-notes.txt
    fi
    
    echo ""
else
    echo '<div class="error">Invalid request method</div>'
fi 