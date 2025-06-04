#!/bin/bash

# Wordlist List Handler
# Purpose: List all uploaded wordlists with metadata
# Input: None
# Output: HTML formatted list of uploaded wordlists

source "$(dirname "$0")/../../core.sh"

UPLOAD_DIR="uploads/wordlists"

# Function to format file size
format_size() {
    local size="$1"
    if [[ "$size" -gt 1048576 ]]; then
        echo "$(( size / 1048576 ))MB"
    elif [[ "$size" -gt 1024 ]]; then
        echo "$(( size / 1024 ))KB"
    else
        echo "${size}B"
    fi
}

# Function to format timestamp
format_date() {
    local timestamp="$1"
    if command -v date >/dev/null 2>&1; then
        date -r "$timestamp" "+%Y-%m-%d %H:%M" 2>/dev/null || echo "Unknown"
    else
        echo "Unknown"
    fi
}

# Check if upload directory exists
if [[ ! -d "$UPLOAD_DIR" ]]; then
    echo '<div class="no-uploads">No uploaded wordlists found</div>'
    exit 0
fi

# Get list of uploaded files (exclude metadata files)
WORDLIST_FILES=($(find "$UPLOAD_DIR" -name "*.txt" -o -name "*.list" -o -name "*.wordlist" -o -name "*.dict" 2>/dev/null | sort -r))

if [[ ${#WORDLIST_FILES[@]} -eq 0 ]]; then
    echo '<div class="no-uploads">'
    echo '<div class="no-uploads-icon">📝</div>'
    echo '<h4>No Uploaded Wordlists</h4>'
    echo '<p>Upload your first wordlist using the form above!</p>'
    echo '</div>'
    exit 0
fi

for file in "${WORDLIST_FILES[@]}"; do
    filename=$(basename "$file")
    metadata_file="$file.meta"
    
    # Default values
    original_name="$filename"
    description=""
    category="Custom"
    upload_time=""
    file_size="0"
    line_count="0"
    
    # Read metadata if available
    if [[ -f "$metadata_file" ]]; then
        original_name=$(grep '"original_name"' "$metadata_file" | cut -d'"' -f4 2>/dev/null || echo "$filename")
        description=$(grep '"description"' "$metadata_file" | cut -d'"' -f4 2>/dev/null || echo "")
        category=$(grep '"category"' "$metadata_file" | cut -d'"' -f4 2>/dev/null || echo "Custom")
        upload_time=$(grep '"upload_time"' "$metadata_file" | cut -d'"' -f4 2>/dev/null || echo "")
        file_size=$(grep '"file_size"' "$metadata_file" | cut -d'"' -f4 2>/dev/null || echo "0")
        line_count=$(grep '"line_count"' "$metadata_file" | cut -d'"' -f4 2>/dev/null || echo "0")
    else
        # Fallback: get basic info from file
        if [[ -f "$file" ]]; then
            file_size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null || echo "0")
            line_count=$(wc -l < "$file" 2>/dev/null || echo "0")
        fi
    fi
    
    # Format values
    size_display=$(format_size "$file_size")
    date_display=$(format_date "$upload_time")
    lines_display=$(printf "%'d" "$line_count" 2>/dev/null || echo "$line_count")
    
    # Generate card using same structure as default wordlists
    echo '<div class="tool-card" data-tool="uploaded">'
    echo '<div class="tool-header">'
    echo '<div class="tool-icon">📤</div>'
    echo '<div class="tool-info">'
    echo "<h3 class=\"tool-title\">$original_name</h3>"
    if [[ -n "$description" ]]; then
        echo "<p class=\"tool-desc\">$description</p>"
    else
        echo "<p class=\"tool-desc\">User uploaded wordlist</p>"
    fi
    echo '</div>'
    echo '</div>'
    echo '<div class="tool-body">'
    echo '<div class="wordlist-info">'
    echo '<div class="info-item">'
    echo "<strong>Category:</strong> $category"
    echo '</div>'
    echo '<div class="info-item">'
    echo "<strong>Size:</strong> $size_display"
    echo '</div>'
    echo '<div class="info-item">'
    echo "<strong>Lines:</strong> $lines_display"
    echo '</div>'
    if [[ -n "$upload_time" ]]; then
        echo '<div class="info-item">'
        echo "<strong>Uploaded:</strong> $date_display"
        echo '</div>'
    fi
    echo '</div>'
    echo '<div class="tool-actions">'
    echo "<a href=\"/api/wordlists/download/$filename\" class=\"tool-btn primary\" download=\"$original_name\">"
    echo '📥 Download Wordlist'
    echo '</a>'
    echo "<button class=\"tool-btn secondary\" onclick=\"copyToClipboard('/api/wordlists/download/$filename')\">"
    echo '📋 Copy URL'
    echo '</button>'
    echo '</div>'
    echo '</div>'
    echo '</div>'
done 