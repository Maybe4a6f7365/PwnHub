#!/bin/bash

source "includes/auth.sh"
source "config.sh"

get_failed_attempts() {
    local ip="$1"
    [ ! -f "data/login_attempts.txt" ] && echo "0" && return
    
    cutoff_time=$(($(date +%s) - 3600))
    grep "^${ip}|" "data/login_attempts.txt" 2>/dev/null | while IFS='|' read -r attempt_ip timestamp; do
        if [ "$timestamp" -gt "$cutoff_time" ]; then
            echo "1"
        fi
    done | wc -l
}

record_failed_attempt() {
    local ip="$1"
    mkdir -p data
    echo "${ip}|$(date +%s)" >> "data/login_attempts.txt"
}

clear_failed_attempts() {
    local ip="$1"
    [ ! -f "data/login_attempts.txt" ] && return
    
    grep -v "^${ip}|" "data/login_attempts.txt" > "data/login_attempts.tmp" 2>/dev/null || true
    mv "data/login_attempts.tmp" "data/login_attempts.txt" 2>/dev/null || true
}

if [ "$REQUEST_METHOD" = "POST" ]; then
    username="${FORM_DATA[username]}"
    password="${FORM_DATA[password]}"
    client_ip="${REMOTE_ADDR:-unknown}"
    
    if [ -z "$username" ] || [ -z "$password" ]; then
        echo '<div class="error">✗ Username and password are required</div>'
        exit 1
    fi
    
    failed_attempts=$(get_failed_attempts "$client_ip")
    if [ "$failed_attempts" -ge "$MAX_LOGIN_ATTEMPTS" ]; then
        echo '<div class="error">✗ Too many failed login attempts. Please try again in 1 hour.</div>'
        exit 1
    fi
    
    username=$(sanitize_username "$username")
    
    login_successful=false
    if [ -f "data/users.txt" ]; then
        while IFS='|' read -r db_username db_password_hash display_name specialty status registration_date; do
            [ -z "$db_username" ] && continue
            [[ "$db_username" =~ ^#.*$ ]] && continue
            
            if [ "$username" = "$db_username" ]; then
                if verify_password "$password" "$db_password_hash"; then
                    SESSION["authenticated"]="true"
                    SESSION["username"]="$username"
                    SESSION["display_name"]="$display_name"
                    SESSION["specialty"]="$specialty"
                    SESSION["login_time"]="$(date '+%Y-%m-%d %H:%M:%S')"
                    save_session
                    
                    # Clear any failed attempts for this IP
                    clear_failed_attempts "$client_ip"
                    
                    # Update user status to online
                    temp_file=$(mktemp)
                    while IFS='|' read -r u p d s st rd; do
                        if [ "$u" = "$username" ]; then
                            echo "${u}|${p}|${d}|${s}|online|${rd}"
                        else
                            echo "${u}|${p}|${d}|${s}|${st}|${rd}"
                        fi
                    done < "data/users.txt" > "$temp_file"
                    mv "$temp_file" "data/users.txt"
                    
                    login_successful=true
                    echo '<div class="success">✓ Login successful! Redirecting...</div>'
                    echo '<script>setTimeout(() => { window.location.reload(); }, 1000);</script>'
                    exit 0
                else
                    break
                fi
            fi
        done < data/users.txt
    fi
    
    if [ "$login_successful" = false ]; then
        record_failed_attempt "$client_ip"
        
        new_failed_count=$((failed_attempts + 1))
        remaining_attempts=$((MAX_LOGIN_ATTEMPTS - new_failed_count))
        
        if [ "$remaining_attempts" -gt 0 ]; then
            echo "<div class='error'>✗ Invalid username or password. $remaining_attempts attempts remaining.</div>"
        else
            echo '<div class="error">✗ Invalid username or password. Account temporarily locked due to too many failed attempts.</div>'
        fi
    fi
else
    echo '<div class="error">Invalid request method</div>'
fi 