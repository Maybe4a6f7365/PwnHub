#!/bin/bash

source "includes/auth.sh"
source "config.sh"

if [ "$REQUEST_METHOD" = "POST" ]; then
    username="${FORM_DATA[username]}"
    password="${FORM_DATA[password]}"
    confirm_password="${FORM_DATA[confirm_password]}"
    display_name="${FORM_DATA[display_name]}"
    specialty="${FORM_DATA[specialty]}"
    
    if [ -z "$username" ] || [ -z "$password" ] || [ -z "$display_name" ] || [ -z "$specialty" ]; then
        echo '<div class="error">✗ All fields are required</div>'
        exit 1
    fi
    
    if [ "$password" != "$confirm_password" ]; then
        echo '<div class="error">✗ Passwords do not match</div>'
        exit 1
    fi
    
    password_error=$(validate_password_strength "$password" "$MIN_PASSWORD_LENGTH")
    if [ $? -ne 0 ]; then
        echo "<div class='error'>✗ $password_error</div>"
        exit 1
    fi
    
    username=$(sanitize_username "$username")
    if [ ${#username} -lt 3 ]; then
        echo '<div class="error">✗ Username must be at least 3 characters long</div>'
        exit 1
    fi
    
    case "$specialty" in
        "Web Expert"|"Pwn Specialist"|"Reverse Engineering"|"Cryptography"|"Forensics"|"OSINT"|"General CTF Player"|"Social Engineering"|"Hardware Hacking"|"Network Security"|"Mobile Security"|"Red Team"|"Blue Team"|"Bug Bounty Hunter"|"Penetration Tester")
            ;;
        *)
            echo '<div class="error">✗ Invalid specialty selected</div>'
            exit 1
            ;;
    esac
    
    display_name=$(echo "$display_name" | sed 's/[|]//g' | head -c 50)
    if [ -z "$display_name" ]; then
        echo '<div class="error">✗ Invalid display name</div>'
        exit 1
    fi
    
    if [ -f "data/users.txt" ]; then
        if grep -q "^${username}|" data/users.txt; then
            echo '<div class="error">✗ Username already exists</div>'
            exit 1
        fi
    fi
    
    hashed_password=$(hash_password "$password")
    if [ $? -ne 0 ]; then
        echo '<div class="error">✗ Failed to secure password. Please try again.</div>'
        exit 1
    fi
    
    registration_date=$(date '+%Y-%m-%d %H:%M:%S')
    
    mkdir -p data
    echo "$username|$hashed_password|$display_name|$specialty|offline|$registration_date" >> data/users.txt
    
    SESSION["authenticated"]="true"
    SESSION["username"]="$username"
    SESSION["display_name"]="$display_name"
    SESSION["specialty"]="$specialty"
    SESSION["login_time"]="$(date '+%Y-%m-%d %H:%M:%S')"
    save_session
    
    echo '<div class="success">✓ Account created successfully! You can now log in.</div>'
    echo '<script>setTimeout(() => { showLogin(); }, 2000);</script>'
else
    echo '<div class="error">Invalid request method</div>'
fi 