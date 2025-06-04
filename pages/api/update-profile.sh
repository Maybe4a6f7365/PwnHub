#!/bin/bash

source "includes/auth.sh"
source "config.sh"

if [ "${SESSION[authenticated]}" != "true" ]; then
    echo '<div class="error">You must be logged in to update your profile.</div>'
    exit 1
fi

DISPLAY_NAME="${FORM_DATA[display_name]}"
SPECIALTY="${FORM_DATA[specialty]}"
CURRENT_PASSWORD="${FORM_DATA[current_password]}"
NEW_PASSWORD="${FORM_DATA[new_password]}"
CONFIRM_PASSWORD="${FORM_DATA[confirm_password]}"

if [ -z "$DISPLAY_NAME" ] || [ -z "$SPECIALTY" ] || [ -z "$CURRENT_PASSWORD" ]; then
    echo '<div class="error">Display name, specialty, and current password are required.</div>'
    exit 1
fi

case "$SPECIALTY" in
    "Web Expert"|"Pwn Specialist"|"Reverse Engineering"|"Cryptography"|"Forensics"|"OSINT"|"General CTF Player"|"Social Engineering"|"Hardware Hacking"|"Network Security"|"Mobile Security"|"Red Team"|"Blue Team"|"Bug Bounty Hunter"|"Penetration Tester")
        ;;
    *)
        echo '<div class="error">Invalid specialty selected.</div>'
        exit 1
        ;;
esac

DISPLAY_NAME=$(echo "$DISPLAY_NAME" | sed 's/[|]//g' | head -c 50)
if [ -z "$DISPLAY_NAME" ]; then
    echo '<div class="error">Invalid display name.</div>'
    exit 1
fi

USERNAME="${SESSION[username]}"
STORED_PASSWORD_HASH=""
while IFS='|' read -r username password_hash display_name specialty status registration_date; do
    [ -z "$username" ] && continue
    [[ "$username" =~ ^#.*$ ]] && continue
    
    if [ "$username" = "$USERNAME" ]; then
        STORED_PASSWORD_HASH="$password_hash"
        break
    fi
done < data/users.txt

if ! verify_password "$CURRENT_PASSWORD" "$STORED_PASSWORD_HASH"; then
    echo '<div class="error">Current password is incorrect.</div>'
    exit 1
fi

FINAL_PASSWORD_HASH="$STORED_PASSWORD_HASH"
if [ -n "$NEW_PASSWORD" ]; then
    if ! password_error=$(validate_password_strength "$NEW_PASSWORD" "$MIN_PASSWORD_LENGTH"); then
        echo "<div class='error'>$password_error</div>"
        exit 1
    fi
    
    if [ "$NEW_PASSWORD" != "$CONFIRM_PASSWORD" ]; then
        echo '<div class="error">New password and confirmation do not match.</div>'
        exit 1
    fi
    
    FINAL_PASSWORD_HASH=$(hash_password "$NEW_PASSWORD")
    if [ -z "$FINAL_PASSWORD_HASH" ]; then
        echo '<div class="error">Failed to secure new password. Please try again.</div>'
        exit 1
    fi
fi

TEMP_FILE=$(mktemp)
while IFS='|' read -r username password_hash display_name specialty status registration_date; do
    [ -z "$username" ] && continue
    
    if [ "$username" = "$USERNAME" ]; then
        echo "${username}|${FINAL_PASSWORD_HASH}|${DISPLAY_NAME}|${SPECIALTY}|${status}|${registration_date}"
    else
        echo "${username}|${password_hash}|${display_name}|${specialty}|${status}|${registration_date}"
    fi
done < data/users.txt > "$TEMP_FILE"

mv "$TEMP_FILE" data/users.txt

SESSION["display_name"]="$DISPLAY_NAME"
SESSION["specialty"]="$SPECIALTY"
save_session

echo '<div class="success">✓ Profile updated successfully!</div>' 