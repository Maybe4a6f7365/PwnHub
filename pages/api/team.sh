#!/bin/bash

if [ "${SESSION[authenticated]}" != "true" ]; then
    echo '<div class="team-section">'
    echo '    <h3 class="team-title">Team Members</h3>'
    echo '    <p class="text-muted">Please log in to see team members</p>'
    echo '</div>'
    exit 0
fi

echo '<div class="team-section">'
echo '    <h3 class="team-title">Team Members</h3>'
echo '    <div class="team-members">'

if [ -f "data/users.txt" ]; then
    while IFS='|' read -r username password_hash display_name specialty status registration_date; do
        [ -z "$username" ] && continue
        [[ "$username" =~ ^#.*$ ]] && continue
        
        if [ -z "$display_name" ] || [ -z "$specialty" ] || [ -z "$status" ]; then
            continue
        fi
        
        avatar_letter=$(echo "$display_name" | head -c 1 | tr '[:lower:]' '[:upper:]')
        
        case "$status" in
            "online") status_class="online" ;;
            "offline") status_class="offline" ;;
            *) status_class="offline" ;;
        esac
        
        current_user_class=""
        if [ "$username" = "${SESSION[username]}" ]; then
            current_user_class="current-user"
        fi
        
        echo "        <div class=\"team-member $current_user_class\">"
        echo "            <div class=\"member-avatar $status_class\">$avatar_letter</div>"
        echo "            <div class=\"member-info\">"
        echo "                <div class=\"member-name\">$display_name</div>"
        echo "                <div class=\"member-specialty\">$specialty</div>"
        echo "            </div>"
        echo "        </div>"
    done < data/users.txt
else
    echo '        <p class="text-muted">No team members found</p>'
fi

echo '    </div>'
echo '</div>'
