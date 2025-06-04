#!/bin/bash

# Wordlist Download Handler
# Purpose: Serve uploaded wordlists securely
# Input: filename parameter from URL path
# Output: File download or error response

UPLOAD_DIR="uploads/wordlists"

# Get filename from dynamic route parameter
FILENAME="${PATH_VARS[filename]}"
FILENAME=$(basename "$FILENAME")  # Security: prevent path traversal

# Validate filename
if [[ -z "$FILENAME" || "$FILENAME" == "." || "$FILENAME" == ".." ]]; then
    echo '<div class="tool-error">File not found</div>'
    exit 0
fi

# Construct file path
FILEPATH="$UPLOAD_DIR/$FILENAME"

# Check if file exists and is readable
if [[ ! -f "$FILEPATH" || ! -r "$FILEPATH" ]]; then
    echo '<div class="tool-error">File not found or not accessible</div>'
    exit 0
fi

# Stream the file content
cat "$FILEPATH" 