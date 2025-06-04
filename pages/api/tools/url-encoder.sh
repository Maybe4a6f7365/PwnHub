#!/bin/bash

# URL Encoder/Decoder Tool

TEXT_INPUT="${FORM_DATA["url-input"]}"
OPERATION="${FORM_DATA["operation"]}"

if [[ -z "$TEXT_INPUT" ]]; then
    echo "<div class='tool-error'>Please enter text to encode/decode</div>"
    exit 0
fi

url_encode() {
    local string="$1"
    echo "$string" | python3 -c "import sys, urllib.parse; print(urllib.parse.quote(sys.stdin.read().strip()))"
}

url_decode() {
    local string="$1"
    echo "$string" | python3 -c "import sys, urllib.parse; print(urllib.parse.unquote(sys.stdin.read().strip()))"
}

echo "<div class='tool-result'>"
echo "<h4>URL Encoder/Decoder Results</h4>"
echo "<div class='url-results'>"

echo "<strong>Original Input:</strong><br>"
echo "<div class='text-box original'>$TEXT_INPUT</div><br>"

case "$OPERATION" in
    "encode")
        echo "<strong>URL Encoded:</strong><br>"
        encoded=$(url_encode "$TEXT_INPUT")
        echo "<div class='text-box encoded'>$encoded</div>"
        
        echo "<br><strong>Common Use Cases:</strong><br>"
        echo "• Encoding URLs with special characters<br>"
        echo "• Preparing data for HTTP GET parameters<br>"
        echo "• Encoding form data for submission<br>"
        ;;
        
    "decode")
        echo "<strong>URL Decoded:</strong><br>"
        decoded=$(url_decode "$TEXT_INPUT")
        echo "<div class='text-box decoded'>$decoded</div>"
        
        echo "<br><strong>Decoded Characters:</strong><br>"
        echo "• %20 → space<br>"
        echo "• %3D → =<br>"
        echo "• %26 → &<br>"
        echo "• %3F → ?<br>"
        ;;
esac

echo "</div>"
echo "</div>"