#!/bin/bash

source config.sh

if [ "${SESSION[authenticated]}" != "true" ]; then
    echo "HTTP/1.1 403 Forbidden"
    echo "Content-Type: text/html"
    echo ""
    echo '<div class="error">Unauthorized access</div>'
    exit 1
fi

CHALLENGE_ID="${FORM_DATA[challenge_id]}"

if [ -z "$CHALLENGE_ID" ]; then
    echo "HTTP/1.1 400 Bad Request"
    echo "Content-Type: text/html"
    echo ""
    echo '<div class="error">Challenge ID is required</div>'
    exit 1
fi

cp data/challenges.txt data/challenges.txt.backup

temp_file=$(mktemp)
while IFS='|' read -r id name category difficulty points description flag assignee files tags status; do
    [ -z "$id" ] && continue
    [[ "$id" =~ ^#.* ]] && {
        echo "$id|$name|$category|$difficulty|$points|$description|$flag|$assignee|$files|$tags|$status" >> "$temp_file"
        continue
    }
    
    if [ "$id" != "$CHALLENGE_ID" ]; then
        echo "$id|$name|$category|$difficulty|$points|$description|$flag|$assignee|$files|$tags|$status" >> "$temp_file"
    fi
done < data/challenges.txt

mv "$temp_file" data/challenges.txt

if [ -f data/checklists.txt ]; then
    temp_file2=$(mktemp)
    while IFS='|' read -r challenge_id item_text status assignee timestamp; do
        [ -z "$challenge_id" ] && continue
        [[ "$challenge_id" =~ ^#.* ]] && {
            echo "$challenge_id|$item_text|$status|$assignee|$timestamp" >> "$temp_file2"
            continue
        }
        if [ "$challenge_id" != "$CHALLENGE_ID" ]; then
            echo "$challenge_id|$item_text|$status|$assignee|$timestamp" >> "$temp_file2"
        fi
    done < data/checklists.txt
    mv "$temp_file2" data/checklists.txt
fi

if [ -f data/flags.txt ]; then
    temp_file3=$(mktemp)
    while IFS='|' read -r challenge_id flag_content submitter timestamp; do
        [ -z "$challenge_id" ] && continue
        [[ "$challenge_id" =~ ^#.* ]] && {
            echo "$challenge_id|$flag_content|$submitter|$timestamp" >> "$temp_file3"
            continue
        }
        if [ "$challenge_id" != "$CHALLENGE_ID" ]; then
            echo "$challenge_id|$flag_content|$submitter|$timestamp" >> "$temp_file3"
        fi
    done < data/flags.txt
    mv "$temp_file3" data/flags.txt
fi

if [ -f data/uploads.txt ]; then
    temp_file4=$(mktemp)
    while IFS='|' read -r challenge_id filename uploader upload_time file_size; do
        [ -z "$challenge_id" ] && continue
        [[ "$challenge_id" =~ ^#.* ]] && {
            echo "$challenge_id|$filename|$uploader|$upload_time|$file_size" >> "$temp_file4"
            continue
        }
        if [ "$challenge_id" != "$CHALLENGE_ID" ]; then
            echo "$challenge_id|$filename|$uploader|$upload_time|$file_size" >> "$temp_file4"
        fi
    done < data/uploads.txt
    mv "$temp_file4" data/uploads.txt
fi

if [ -f data/team-notes.txt ]; then
    temp_file5=$(mktemp)
    while IFS='|' read -r challenge_id notes last_updated updated_by; do
        [ -z "$challenge_id" ] && continue
        [[ "$challenge_id" =~ ^#.* ]] && {
            echo "$challenge_id|$notes|$last_updated|$updated_by" >> "$temp_file5"
            continue
        }
        if [ "$challenge_id" != "$CHALLENGE_ID" ]; then
            echo "$challenge_id|$notes|$last_updated|$updated_by" >> "$temp_file5"
        fi
    done < data/team-notes.txt
    mv "$temp_file5" data/team-notes.txt
fi

if [ -d "uploads/$CHALLENGE_ID" ]; then
    rm -rf "uploads/$CHALLENGE_ID"
fi

echo "HTTP/1.1 200 OK"
echo "Content-Type: text/html"
echo ""
echo '<div class="success">Challenge deleted successfully!</div>' 