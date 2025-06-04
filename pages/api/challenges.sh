#!/bin/bash

source includes/icons.sh

search_query=""
if [[ -n "$QUERY_STRING" ]]; then
    search_query=$(echo "$QUERY_STRING" | sed -n 's/.*search=\([^&]*\).*/\1/p' | sed 's/%20/ /g' | sed 's/+/ /g')
fi

get_category_icon() {
    case "$1" in
        "Web") echo "$ICON_WEB" ;;
        "Pwn") echo "$ICON_PWN" ;;
        "Crypto") echo "$ICON_CRYPTO" ;;
        "Reverse") echo "$ICON_REVERSE" ;;
        "Forensics") echo "$ICON_FORENSICS" ;;
        "Misc") echo "$ICON_MISC" ;;
        *) echo "$ICON_DEFAULT" ;;
    esac
}

get_status_info() {
    case "$1" in
        "solved") echo "$ICON_CHECK|status-solved|Solved" ;;
        "in-progress") echo "$ICON_CLOCK|status-in-progress|In Progress" ;;
        "not-started") echo "$ICON_CIRCLE|status-not-started|Not Started" ;;
        *) echo "$ICON_CIRCLE|status-not-started|Not Started" ;;
    esac
}

cat << EOF
<div id="challenges-list" class="challenges-grid">
EOF

challenge_count=0
while IFS='|' read -r id name category difficulty points description flag assignee files tags status; do
    [ -z "$id" ] && continue
    [[ "$id" =~ ^#.* ]] && continue
    
    challenge_count=$((challenge_count + 1))
    
    if [ -n "$search_query" ]; then
        if ! echo "${name}|${category}|${tags}" | grep -qi "$search_query"; then
            continue
        fi
    fi
    
    category_icon=$(get_category_icon "$category")
    status_info=$(get_status_info "$status")
    status_icon=$(echo "$status_info" | cut -d'|' -f1)
    status_class=$(echo "$status_info" | cut -d'|' -f2)
    status_text=$(echo "$status_info" | cut -d'|' -f3)
    
    if [ -z "$assignee" ]; then
        assignee_display="Unassigned"
    else
        assignee_display="$assignee"
    fi
    
    case "$difficulty" in
        "Easy") difficulty_class="difficulty-easy" ;;
        "Medium") difficulty_class="difficulty-medium" ;;
        "Hard") difficulty_class="difficulty-hard" ;;
        *) difficulty_class="difficulty-easy" ;;
    esac
    
    tag_elements=""
    if [ -n "$tags" ]; then
        IFS=',' read -ra tag_array <<< "$tags"
        for tag in "${tag_array[@]}"; do
            tag_elements="${tag_elements}<span class=\"tag\">#${tag}</span>"
        done
    fi
    
    cat << EOF
    <div class="challenge-card" onclick="loadChallengeDetail('${id}')">
        <div class="challenge-header">
            <div class="challenge-category">
                <span class="category-icon">${category_icon}</span>
                <span>${category}</span>
            </div>
            <div class="challenge-status">
                <span class="status-badge ${status_class}">
                    <span>${status_icon}</span>
                    <span>${status_text}</span>
                </span>
            </div>
        </div>
        
        <h3 class="challenge-name">${name}</h3>
        
        <div class="challenge-meta">
            <div class="challenge-points">
                <span>${TROPHY_ICON}</span>
                <span>${points} pts</span>
            </div>
            <div class="challenge-assignee">
                <span>${USER_ICON}</span>
                <span>${assignee_display}</span>
            </div>
        </div>
        
        <div class="flex justify-between align-center mt-2">
            <span class="difficulty-badge ${difficulty_class}">${difficulty}</span>
            <button class="btn-small btn-danger" onclick="deleteChallenge('${id}', event)" title="Delete Challenge">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polyline points="3,6 5,6 21,6"/>
                    <path d="M19,6v14a2,2 0 0,1 -2,2H7a2,2 0 0,1 -2,-2V6m3,0V4a2,2 0 0,1 2,-2h4a2,2 0 0,1 2,2v2"/>
                    <line x1="10" y1="11" x2="10" y2="17"/>
                    <line x1="14" y1="11" x2="14" y2="17"/>
                </svg>
            </button>
        </div>
        
        <div class="challenge-tags">
            ${tag_elements}
        </div>
    </div>
EOF
done < data/challenges.txt

if [ "$challenge_count" -eq 0 ]; then
    cat << EOF
    <div class="no-challenges-message">
        <h3>No Challenges Yet</h3>
        <p>Get started by adding your first challenge!</p>
        <button class="btn btn-primary" onclick="openAddChallengeModal()">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <line x1="12" y1="5" x2="12" y2="19"/>
                <line x1="5" y1="12" x2="19" y2="12"/>
            </svg>
            Add First Challenge
        </button>
    </div>
EOF
fi

echo "</div>" 