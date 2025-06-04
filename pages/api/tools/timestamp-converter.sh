#!/bin/bash

# Timestamp Converter Tool

TIMESTAMP_INPUT="${FORM_DATA["timestamp-input"]}"

if [[ -z "$TIMESTAMP_INPUT" ]]; then
    echo "<div class='tool-error'>Please enter a timestamp or date to convert</div>"
    exit 0
fi

echo "<div class='tool-result'>"
echo "<h4>Timestamp Converter Results</h4>"
echo "<div class='timestamp-results'>"

echo "<strong>Input:</strong><br>"
echo "<div class='text-box'>$TIMESTAMP_INPUT</div><br>"

if [[ "$TIMESTAMP_INPUT" =~ ^[0-9]+$ ]]; then
    echo "<strong>Unix Timestamp → Human Readable:</strong><br>"
    
    if [[ ${#TIMESTAMP_INPUT} -eq 10 ]]; then
        human_date=$(date -d "@$TIMESTAMP_INPUT" 2>/dev/null)
        if [[ $? -eq 0 ]]; then
            echo "<div class='result-box'>"
            echo "<strong>Local Time:</strong> $human_date<br>"
            echo "<strong>UTC:</strong> $(date -u -d "@$TIMESTAMP_INPUT" 2>/dev/null)<br>"
            echo "<strong>ISO 8601:</strong> $(date -u -d "@$TIMESTAMP_INPUT" '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null)<br>"
            echo "</div>"
        else
            echo "<div class='tool-error'>Invalid timestamp</div>"
        fi
    elif [[ ${#TIMESTAMP_INPUT} -eq 13 ]]; then
        seconds=$((TIMESTAMP_INPUT / 1000))
        human_date=$(date -d "@$seconds" 2>/dev/null)
        if [[ $? -eq 0 ]]; then
            echo "<div class='result-box'>"
            echo "<strong>Detected:</strong> Milliseconds since epoch<br>"
            echo "<strong>Local Time:</strong> $human_date<br>"
            echo "<strong>UTC:</strong> $(date -u -d "@$seconds" 2>/dev/null)<br>"
            echo "<strong>ISO 8601:</strong> $(date -u -d "@$seconds" '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null)<br>"
            echo "</div>"
        else
            echo "<div class='tool-error'>Invalid timestamp</div>"
        fi
    else
        echo "<div class='tool-error'>Unrecognized timestamp format. Expected 10 digits (seconds) or 13 digits (milliseconds)</div>"
    fi
    
elif [[ "$TIMESTAMP_INPUT" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2} ]] || [[ "$TIMESTAMP_INPUT" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T ]]; then
    # ISO 8601 or similar date format
    echo "<strong>Date → Unix Timestamp:</strong><br>"
    
    unix_timestamp=$(date -d "$TIMESTAMP_INPUT" '+%s' 2>/dev/null)
    if [[ $? -eq 0 ]]; then
        unix_ms=$((unix_timestamp * 1000))
        echo "<div class='result-box'>"
        echo "<strong>Unix Timestamp (seconds):</strong> $unix_timestamp<br>"
        echo "<strong>Unix Timestamp (milliseconds):</strong> $unix_ms<br>"
        echo "<strong>Hex (seconds):</strong> 0x$(printf '%x' $unix_timestamp)<br>"
        echo "</div>"
    else
        echo "<div class='tool-error'>Invalid date format</div>"
    fi
    
else
    echo "<strong>Date → Unix Timestamp:</strong><br>"
    
    unix_timestamp=$(date -d "$TIMESTAMP_INPUT" '+%s' 2>/dev/null)
    if [[ $? -eq 0 ]]; then
        unix_ms=$((unix_timestamp * 1000))
        echo "<div class='result-box'>"
        echo "<strong>Parsed Date:</strong> $(date -d "$TIMESTAMP_INPUT" 2>/dev/null)<br>"
        echo "<strong>Unix Timestamp (seconds):</strong> $unix_timestamp<br>"
        echo "<strong>Unix Timestamp (milliseconds):</strong> $unix_ms<br>"
        echo "<strong>Hex (seconds):</strong> 0x$(printf '%x' $unix_timestamp)<br>"
        echo "</div>"
    else
        echo "<div class='tool-error'>Unable to parse date format. Try formats like:<br>"
        echo "• Unix timestamp: 1634567890<br>"
        echo "• ISO 8601: 2021-10-18T10:31:30Z<br>"
        echo "• Human readable: Oct 18 2021 10:31:30<br>"
        echo "• Simple date: 2021-10-18</div>"
    fi
fi

current_timestamp=$(date '+%s')
echo "<br><strong>Current Timestamp Reference:</strong><br>"
echo "<div class='reference-box'>"
echo "<strong>Current Unix Timestamp:</strong> $current_timestamp<br>"
echo "<strong>Current Time:</strong> $(date)<br>"
echo "<strong>Current UTC:</strong> $(date -u)<br>"
echo "</div>"

echo "<br><strong>Common Reference Points:</strong><br>"
echo "<div class='reference-box'>"
echo "<strong>Unix Epoch (1970-01-01):</strong> 0<br>"
echo "<strong>Y2K (2000-01-01):</strong> 946684800<br>"
echo "<strong>Year 2038 Problem:</strong> 2147483647<br>"
echo "</div>"

echo "</div>"
echo "</div>" 