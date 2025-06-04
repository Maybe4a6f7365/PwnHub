#!/bin/bash

# PwnHub Authentication Library
# Provides secure password hashing and verification functions

# Generate a random salt
generate_salt() {
    openssl rand -hex 16 2>/dev/null || xxd -l 16 -p /dev/urandom 2>/dev/null || date +%s%N | sha256sum | head -c 32
}

# Hash password with salt using SHA-256
hash_password() {
    local password="$1"
    local salt="${2:-$(generate_salt)}"
    
    if [[ -z "$password" ]]; then
        echo "Error: Password cannot be empty" >&2
        return 1
    fi
    
    # Use 1000 rounds of hashing for security
    local hash="$password$salt"
    for i in {1..1000}; do
        hash=$(echo -n "$hash" | sha256sum | cut -d' ' -f1)
    done
    
    echo "${salt}:${hash}"
}

# Verify password against stored hash
verify_password() {
    local password="$1"
    local stored_hash="$2"
    
    if [[ -z "$password" || -z "$stored_hash" ]]; then
        return 1
    fi
    
    # Extract salt from stored hash
    local salt="${stored_hash%%:*}"
    local expected_hash="${stored_hash##*:}"
    
    # Hash the provided password with the same salt
    local computed_hash=$(hash_password "$password" "$salt")
    local computed_hash_only="${computed_hash##*:}"
    
    # Compare hashes
    if [[ "$computed_hash_only" == "$expected_hash" ]]; then
        return 0
    else
        return 1
    fi
}

# Migrate plaintext password to hashed format
migrate_password() {
    local plaintext="$1"
    hash_password "$plaintext"
}

# Generate secure random password
generate_password() {
    local length="${1:-16}"
    openssl rand -base64 "$length" 2>/dev/null | tr -d "=+/" | cut -c1-"$length" || \
    xxd -l "$length" -p /dev/urandom 2>/dev/null | cut -c1-"$length" || \
    date +%s%N | sha256sum | head -c "$length"
}

# Check if password meets security requirements
validate_password_strength() {
    local password="$1"
    local min_length="${2:-8}"
    
    if [[ ${#password} -lt $min_length ]]; then
        echo "Password must be at least $min_length characters long"
        return 1
    fi
    
    # Check for at least one number
    if ! echo "$password" | grep -q '[0-9]'; then
        echo "Password must contain at least one number"
        return 1
    fi
    
    # Check for at least one letter
    if ! echo "$password" | grep -q '[a-zA-Z]'; then
        echo "Password must contain at least one letter"
        return 1
    fi
    
    return 0
}

# Sanitize username input
sanitize_username() {
    local username="$1"
    # Remove any characters that aren't alphanumeric, underscore, or hyphen
    echo "$username" | sed 's/[^a-zA-Z0-9_-]//g' | head -c 32
}

# Generate secure session token
generate_session_token() {
    openssl rand -hex 32 2>/dev/null || xxd -l 32 -p /dev/urandom 2>/dev/null || date +%s%N | sha256sum | head -c 64
} 