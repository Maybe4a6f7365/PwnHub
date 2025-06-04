#!/bin/bash
echo "Content-Type: text/html"
echo ""

get_next_id() {
    if [ ! -f data/challenges.txt ]; then
        echo "1"
        return
    fi
    
    last_id=0
    while IFS='|' read -r id name category difficulty points description flag assignee files tags status; do
        [ -z "$id" ] && continue
        [[ "$id" =~ ^#.* ]] && continue
        if [ "$id" -gt "$last_id" ]; then
            last_id="$id"
        fi
    done < data/challenges.txt
    
    echo $((last_id + 1))
}

if [ "$REQUEST_METHOD" = "POST" ]; then
    name="${FORM_DATA[name]}"
    category="${FORM_DATA[category]}"
    points="${FORM_DATA[points]}"
    difficulty="${FORM_DATA[difficulty]}"
    description="${FORM_DATA[description]}"
    assignee="${FORM_DATA[assignee]}"
    tags="${FORM_DATA[tags]}"
    
    next_id=$(get_next_id)
    status="not-started"
    flag=""
    files=""
    
    if [ -n "$tags" ]; then
        tags=$(echo "$tags" | sed 's/ *, */,/g; s/^,//; s/,$//; s/ /_/g')
    fi
    
    if [ -n "$name" ] && [ -n "$category" ] && [ -n "$points" ] && [ -n "$difficulty" ]; then
        echo "${next_id}|${name}|${category}|${difficulty}|${points}|${description}|${flag}|${assignee}|${files}|${tags}|${status}" >> data/challenges.txt
        
        echo "<div class=\"success\">Challenge added successfully</div>"
    else
        echo "<div class=\"error\">Error: Missing required fields (name: '$name', category: '$category', points: '$points', difficulty: '$difficulty')</div>"
    fi
else
    echo "<div class=\"error\">Error: Invalid request method</div>"
fi 