# allow-uploads
#!/bin/bash

# Wordlist Upload Handler
# Purpose: Handle user-uploaded wordlists with security validation
# Input: multipart/form-data with file upload
# Output: HTML success/error response

source "$(dirname "$0")/../../core.sh"

# Security settings
MAX_FILE_SIZE=52428800  # 50MB limit
ALLOWED_EXTENSIONS=("txt" "list" "wordlist" "dict")
UPLOAD_DIR="uploads/wordlists"

# Ensure upload directory exists
mkdir -p "$UPLOAD_DIR"

# Function to sanitize filename
sanitize_filename() {
    local filename="$1"
    # Remove path traversal attempts and dangerous characters
    filename=$(basename "$filename")
    filename="${filename//[^a-zA-Z0-9._-]/}"
    # Limit filename length
    if [[ ${#filename} -gt 100 ]]; then
        filename="${filename:0:100}"
    fi
    echo "$filename"
}

# Function to validate file extension
validate_extension() {
    local filename="$1"
    local extension="${filename##*.}"
    extension=$(echo "$extension" | tr '[:upper:]' '[:lower:]')
    
    for allowed in "${ALLOWED_EXTENSIONS[@]}"; do
        if [[ "$extension" == "$allowed" ]]; then
            return 0
        fi
    done
    return 1
}

# Function to count lines in file
count_lines() {
    local filepath="$1"
    wc -l < "$filepath" 2>/dev/null || echo "0"
}

# Function to get file size
get_file_size() {
    local filepath="$1"
    stat -f%z "$filepath" 2>/dev/null || stat -c%s "$filepath" 2>/dev/null || echo "0"
}

# Check if file was uploaded (using FILE_UPLOADS for multipart uploads)
if [[ -z "${FILE_UPLOADS[wordlist-file]}" ]]; then
    echo '<div class="tool-error">Please select a wordlist file to upload</div>'
    exit 0
fi

# Get uploaded file info
UPLOADED_FILE="${FILE_UPLOADS[wordlist-file]}"
FILENAME="${FILE_UPLOAD_NAMES[wordlist-file]}"
DESCRIPTION="${FORM_DATA[wordlist-description]:-""}"
CATEGORY="${FORM_DATA[wordlist-category]:-"Custom"}"

# Sanitize inputs
FILENAME=$(sanitize_filename "$FILENAME")
DESCRIPTION=$(echo "$DESCRIPTION" | sed 's/[<>&"]/\\&/g' | head -c 200)
CATEGORY=$(echo "$CATEGORY" | sed 's/[<>&"]/\\&/g' | head -c 50)

# Validate filename
if [[ -z "$FILENAME" ]]; then
    echo '<div class="tool-error">Invalid filename provided</div>'
    exit 0
fi

# Validate file extension
if ! validate_extension "$FILENAME"; then
    echo '<div class="tool-error">Invalid file type. Allowed extensions: txt, list, wordlist, dict</div>'
    exit 0
fi

# Check if uploaded file exists
if [[ ! -f "$UPLOADED_FILE" ]]; then
    echo '<div class="tool-error">Upload failed - file not received</div>'
    exit 0
fi

# Validate file size
FILE_SIZE=$(get_file_size "$UPLOADED_FILE")
if [[ "$FILE_SIZE" -gt "$MAX_FILE_SIZE" ]]; then
    echo '<div class="tool-error">File too large. Maximum size: 50MB</div>'
    rm -f "$UPLOADED_FILE"
    exit 0
fi

# Check if file is empty
if [[ "$FILE_SIZE" -eq 0 ]]; then
    echo '<div class="tool-error">Empty file uploaded</div>'
    rm -f "$UPLOADED_FILE"
    exit 0
fi

# Generate unique filename to prevent conflicts
TIMESTAMP=$(date +%s)
SAFE_FILENAME="${TIMESTAMP}_${FILENAME}"
DESTINATION="$UPLOAD_DIR/$SAFE_FILENAME"

# Move file to destination
if mv "$UPLOADED_FILE" "$DESTINATION"; then
    chmod 644 "$DESTINATION"
    
    # Count lines for statistics
    LINE_COUNT=$(count_lines "$DESTINATION")
    
    # Format file size
    if [[ "$FILE_SIZE" -gt 1048576 ]]; then
        SIZE_DISPLAY="$(( FILE_SIZE / 1048576 ))MB"
    elif [[ "$FILE_SIZE" -gt 1024 ]]; then
        SIZE_DISPLAY="$(( FILE_SIZE / 1024 ))KB"
    else
        SIZE_DISPLAY="${FILE_SIZE}B"
    fi
    
    # Create metadata file
    METADATA_FILE="$UPLOAD_DIR/$SAFE_FILENAME.meta"
    cat > "$METADATA_FILE" << EOF
{
    "original_name": "$FILENAME",
    "description": "$DESCRIPTION",
    "category": "$CATEGORY",
    "upload_time": "$TIMESTAMP",
    "file_size": "$FILE_SIZE",
    "line_count": "$LINE_COUNT",
    "uploader_ip": "${REMOTE_ADDR:-unknown}"
}
EOF
    
    # Display success response
    echo '<div class="upload-success">'
    echo '<div class="success-header">'
    echo '<div class="success-icon">✅</div>'
    echo '<h4>Wordlist Uploaded Successfully!</h4>'
    echo '</div>'
    echo '<div class="upload-details">'
    echo '<div class="detail-item">'
    echo "<strong>Filename:</strong> $FILENAME"
    echo '</div>'
    echo '<div class="detail-item">'
    echo "<strong>Category:</strong> $CATEGORY"
    echo '</div>'
    echo '<div class="detail-item">'
    echo "<strong>Size:</strong> $SIZE_DISPLAY"
    echo '</div>'
    echo '<div class="detail-item">'
    echo "<strong>Lines:</strong> $(printf "%'d" "$LINE_COUNT")"
    echo '</div>'
    if [[ -n "$DESCRIPTION" ]]; then
        echo '<div class="detail-item">'
        echo "<strong>Description:</strong> $DESCRIPTION"
        echo '</div>'
    fi
    echo '</div>'
    echo '<div class="upload-actions">'
    echo "<a href=\"/api/wordlists/download/$SAFE_FILENAME\" class=\"tool-btn primary\" download=\"$FILENAME\">"
    echo '📥 Download'
    echo '</a>'
    echo "<button class=\"tool-btn secondary\" onclick=\"copyToClipboard('/api/wordlists/download/$SAFE_FILENAME')\">"
    echo '📋 Copy URL'
    echo '</button>'
    echo '</div>'
    echo '</div>'
    
    # The refresh is now handled in JavaScript, no need for script tag here
    
else
    echo '<div class="tool-error">Failed to save uploaded file</div>'
    rm -f "$UPLOADED_FILE"
    exit 0
fi 