#!/bin/bash

source includes/icons.sh

cat << EOF
<div class="team-status-container">
EOF

total_points=0
total_solved=0
total_members=0
online_members=0

while IFS='|' read -r id name category points status assignee difficulty tags; do
    [ -z "$id" ] && continue
    if [ "$status" = "solved" ]; then
        total_solved=$((total_solved + 1))
        total_points=$((total_points + points))
    fi
done < data/challenges.txt

if [ -f "data/users.txt" ]; then
    while IFS='|' read -r username password display_name specialty status; do
        [ -z "$username" ] && continue
        total_members=$((total_members + 1))
        if [ "$status" = "online" ]; then
            online_members=$((online_members + 1))
        fi
    done < data/users.txt
fi

echo '<div class="content-header">'
echo '    <h1 class="content-title">Team Status</h1>'
echo '</div>'
echo ''
echo '<div class="stats-grid">'
echo '    <div class="stat-card">'
echo "        <div class=\"stat-icon\">${TROPHY_ICON_24}</div>"
echo "        <div class=\"stat-value\">${total_points}</div>"
echo '        <div class="stat-label">Total Points</div>'
echo '    </div>'
echo '    '
echo '    <div class="stat-card">'
echo "        <div class=\"stat-icon\">${TARGET_ICON_24}</div>"
echo "        <div class=\"stat-value\">${total_solved}</div>"
echo '        <div class="stat-label">Challenges Solved</div>'
echo '    </div>'
echo '    '
echo '    <div class="stat-card">'
echo "        <div class=\"stat-icon\">${USERS_ICON_24}</div>"
echo "        <div class=\"stat-value\">${total_members}</div>"
echo '        <div class="stat-label">Team Members</div>'
echo '    </div>'
echo '    '
echo '    <div class="stat-card">'
echo "        <div class=\"stat-icon\">${USERS_ICON_24}</div>"
echo "        <div class=\"stat-value\">${online_members}</div>"
echo '        <div class="stat-label">Online Now</div>'
echo '    </div>'
echo '</div>'
echo ''

if [ "${SESSION[authenticated]}" = "true" ]; then
    echo '<div class="current-session-info">'
    echo '    <h2 style="color: var(--accent-primary); margin: 2rem 0 1rem 0;">Current Session</h2>'
    echo '    <div class="session-card">'
    echo "        <div class=\"session-user\"><strong>User:</strong> ${SESSION[display_name]} (${SESSION[username]})</div>"
    echo "        <div class=\"session-specialty\"><strong>Specialty:</strong> ${SESSION[specialty]}</div>"
    echo "        <div class=\"session-login\"><strong>Login Time:</strong> ${SESSION[login_time]}</div>"
    echo '        <button class="btn btn-logout" hx-post="/api/logout" hx-target="#logout-response">Logout</button>'
    echo '        <div id="logout-response"></div>'
    echo '    </div>'
    echo '</div>'
fi

echo '<h2 style="color: var(--accent-primary); margin: 2rem 0 1rem 0;">Team Members</h2>'
echo ''
echo '<div class="team-members-grid">'

if [ -f "data/users.txt" ]; then
    while IFS='|' read -r username password display_name specialty status; do
        [ -z "$username" ] && continue
        
        avatar_initial="${display_name:0:1}"
        
        challenges_count=0
        if [ -f "data/challenges.txt" ]; then
            while IFS='|' read -r id name category points chall_status assignee difficulty tags; do
                [ -z "$id" ] && continue
                if [ "$assignee" = "$display_name" ]; then
                    challenges_count=$((challenges_count + 1))
                fi
            done < data/challenges.txt
        fi
        
        case "$status" in
            "online") 
                status_class="status-online" 
                status_text="Online"
                ;;
            "away") 
                status_class="status-away" 
                status_text="Away"
                ;;
            "offline") 
                status_class="status-offline" 
                status_text="Offline"
                ;;
            *) 
                status_class="status-offline" 
                status_text="Offline"
                ;;
        esac
        
        card_class="team-member-card"
        if [ "${SESSION[username]}" = "$username" ]; then
            card_class="team-member-card current-user-card"
        fi
        
        echo "    <div class=\"${card_class}\">"
        echo '        <div class="member-card-header">'
        echo '            <div class="member-card-avatar">'
        echo "                ${avatar_initial}"
        echo "                <div class=\"${status_class} status-indicator\"></div>"
        echo '            </div>'
        echo '            <div class="member-card-info">'
        echo "                <h3 class=\"member-card-name\">${display_name}</h3>"
        echo "                <div class=\"member-card-specialty\">${specialty}</div>"
        echo "                <div class=\"member-card-status\">${status_text}</div>"
        if [ "${SESSION[username]}" = "$username" ]; then
            echo '                <div class="current-user-badge">You</div>'
        fi
        echo '            </div>'
        echo '        </div>'
        echo '        '
        echo '        <div class="member-card-stats">'
        echo "            Assigned Challenges: ${challenges_count}"
        echo '        </div>'
        echo '        '
        echo '        <div class="member-card-actions">'
        echo '            <button class="btn btn-secondary">'
        echo "                ${MESSAGE_ICON}"
        echo '                <span>Message</span>'
        echo '            </button>'
        echo '            <button class="btn">'
        echo "                ${USER_PLUS_ICON}"
        echo '                <span>Assign</span>'
        echo '            </button>'
        echo '        </div>'
        echo '    </div>'
    done < data/users.txt
else
    echo '    <div class="error">No user data available</div>'
fi

echo '</div>'
echo '</div>' 