#!/bin/bash

if [ "$REQUEST_METHOD" = "POST" ]; then
    challenge_id="${FORM_DATA[challenge_id]}"
    uploader="${FORM_DATA[uploader]:-Anonymous}"
    
    mkdir -p uploads
    mkdir -p "uploads/${challenge_id}"
    
    [ ! -f data/uploads.txt ] && touch data/uploads.txt
    
    if [ -n "${FORM_DATA[filename]}" ] && [ -n "${FORM_DATA[content]}" ]; then
        filename="${FORM_DATA[filename]}"
        content="${FORM_DATA[content]}"
        
        case "${filename##*.}" in
            "py"|"sh"|"txt"|"md"|"js"|"php"|"c"|"cpp"|"java"|"rb"|"go"|"zip"|"tar"|"gz")
                echo "$content" > "uploads/${challenge_id}/${filename}"
                
                file_size=$(stat -c%s "uploads/${challenge_id}/${filename}" 2>/dev/null || echo "0")
                file_size_human=$(numfmt --to=iec --suffix=B "$file_size" 2>/dev/null || echo "${file_size}B")
                
                timestamp=$(date "+%Y-%m-%d %H:%M:%S")
                echo "${challenge_id}|${filename}|${uploader}|${timestamp}|${file_size_human}" >> data/uploads.txt
                
                echo '<div class="success">✓ File uploaded successfully</div>'
                ;;
            *)
                echo '<div class="error">File type not allowed</div>'
                ;;
        esac
    else
        echo '<div class="error">No file provided</div>'
    fi
else
    echo '<div class="error">Only POST requests are allowed</div>'
fi 