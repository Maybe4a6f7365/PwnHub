#!/bin/bash

# Hidden Message Analyzer Tool

TEXT_INPUT="${FORM_DATA["hidden-input"]}"

if [[ -z "$TEXT_INPUT" ]]; then
    echo "<div class='tool-error'>Please enter text to analyze for hidden messages</div>"
    exit 0
fi

echo "<div class='tool-result'>"
echo "<h4>Hidden Message Analysis Results</h4>"
echo "<div class='stego-results'>"

echo "<strong>Input Text:</strong><br>"
echo "<div class='text-box'>$TEXT_INPUT</div><br>"

echo "<strong>🔍 Analysis Results:</strong><br>"

echo "<div class='analysis-section'>"
echo "<h5>📝 First Letter of Each Word:</h5>"
first_letters=$(echo "$TEXT_INPUT" | grep -o '\b\w' | tr -d '\n')
echo "<div class='result-box'>"
echo "<strong>Extracted:</strong> $first_letters<br>"
if [[ ${#first_letters} -gt 0 ]]; then
    echo "<strong>Lowercase:</strong> $(echo "$first_letters" | tr '[:upper:]' '[:lower:]')<br>"
fi
echo "</div>"
echo "</div>"

echo "<div class='analysis-section'>"
echo "<h5>📝 Last Letter of Each Word:</h5>"
last_letters=""
for word in $TEXT_INPUT; do
    clean_word=$(echo "$word" | sed 's/[^a-zA-Z0-9]//g')
    if [[ -n "$clean_word" ]]; then
        last_letters+="${clean_word: -1}"
    fi
done
echo "<div class='result-box'>"
echo "<strong>Extracted:</strong> $last_letters<br>"
if [[ ${#last_letters} -gt 0 ]]; then
    echo "<strong>Lowercase:</strong> $(echo "$last_letters" | tr '[:upper:]' '[:lower:]')<br>"
fi
echo "</div>"
echo "</div>"

echo "<div class='analysis-section'>"
echo "<h5>🔤 Capital Letters Only:</h5>"
capitals=$(echo "$TEXT_INPUT" | grep -o '[A-Z]' | tr -d '\n')
echo "<div class='result-box'>"
echo "<strong>Extracted:</strong> $capitals<br>"
if [[ ${#capitals} -gt 0 ]]; then
    echo "<strong>As lowercase:</strong> $(echo "$capitals" | tr '[:upper:]' '[:lower:]')<br>"
fi
echo "</div>"
echo "</div>"

echo "<div class='analysis-section'>"
echo "<h5>🔢 Nth Character Patterns:</h5>"
text_clean=$(echo "$TEXT_INPUT" | sed 's/[^a-zA-Z0-9]//g')
echo "<div class='pattern-grid'>"

for n in 2 3 4 5; do
    nth_chars=""
    for (( i=$((n-1)); i<${#text_clean}; i+=n )); do
        nth_chars+="${text_clean:$i:1}"
    done
    echo "<div class='pattern-item'>"
    echo "<strong>Every ${n}th character:</strong> $nth_chars"
    echo "</div>"
done

echo "</div>"
echo "</div>"

echo "<div class='analysis-section'>"
echo "<h5>📄 Line-based Analysis:</h5>"
line_count=$(echo "$TEXT_INPUT" | wc -l)
echo "<div class='result-box'>"
echo "<strong>Total lines:</strong> $line_count<br>"

if [[ $line_count -gt 1 ]]; then
    line_first=""
    while IFS= read -r line; do
        if [[ -n "$line" ]]; then
            first_char=$(echo "$line" | head -c 1)
            if [[ "$first_char" =~ [a-zA-Z] ]]; then
                line_first+="$first_char"
            fi
        fi
    done <<< "$TEXT_INPUT"
    echo "<strong>First char of each line:</strong> $line_first<br>"
    
    line_last=""
    while IFS= read -r line; do
        if [[ -n "$line" ]]; then
            last_char="${line: -1}"
            if [[ "$last_char" =~ [a-zA-Z] ]]; then
                line_last+="$last_char"
            fi
        fi
    done <<< "$TEXT_INPUT"
    echo "<strong>Last char of each line:</strong> $line_last<br>"
fi
echo "</div>"
echo "</div>"

echo "<div class='analysis-section'>"
echo "<h5>📏 Word Length Analysis:</h5>"
word_lengths=""
for word in $TEXT_INPUT; do
    clean_word=$(echo "$word" | sed 's/[^a-zA-Z0-9]//g')
    if [[ -n "$clean_word" ]]; then
        word_lengths+="${#clean_word} "
    fi
done
echo "<div class='result-box'>"
echo "<strong>Word lengths:</strong> $word_lengths<br>"
length_letters=""
for length in $word_lengths; do
    if [[ $length -ge 1 && $length -le 26 ]]; then
        letter_index=$((length + 64))
        length_letters+=$(printf "\\$(printf '%03o' $letter_index)")
    fi
done
echo "<strong>As letters (A=1, B=2...):</strong> $length_letters<br>"
echo "</div>"
echo "</div>"

echo "<div class='analysis-section'>"
echo "<h5>🔣 Numeric & ASCII Patterns:</h5>"
numbers=$(echo "$TEXT_INPUT" | grep -o '[0-9]' | tr -d '\n')
echo "<div class='result-box'>"
echo "<strong>All digits:</strong> $numbers<br>"

if [[ -n "$numbers" ]]; then
    ascii_from_numbers=""
    for (( i=0; i<${#numbers}-1; i+=2 )); do
        pair="${numbers:$i:2}"
        if [[ $pair -ge 32 && $pair -le 126 ]]; then
            ascii_from_numbers+=$(printf "\\$(printf '%03o' $pair)")
        fi
    done
    if [[ -n "$ascii_from_numbers" ]]; then
        echo "<strong>Pairs as ASCII:</strong> $ascii_from_numbers<br>"
    fi
fi
echo "</div>"
echo "</div>"

echo "<div class='analysis-section'>"
echo "<h5>💻 Binary & Hex Patterns:</h5>"
echo "<div class='result-box'>"

binary_pattern=$(echo "$TEXT_INPUT" | grep -o '[01]\+' | head -1)
if [[ -n "$binary_pattern" && ${#binary_pattern} -ge 8 ]]; then
    echo "<strong>Binary found:</strong> $binary_pattern<br>"
    if [[ $((${#binary_pattern} % 8)) -eq 0 ]]; then
        binary_ascii=""
        for (( i=0; i<${#binary_pattern}; i+=8 )); do
            byte="${binary_pattern:$i:8}"
            decimal=$((2#$byte))
            if [[ $decimal -ge 32 && $decimal -le 126 ]]; then
                binary_ascii+=$(printf "\\$(printf '%03o' $decimal)")
            fi
        done
        if [[ -n "$binary_ascii" ]]; then
            echo "<strong>Binary as ASCII:</strong> $binary_ascii<br>"
        fi
    fi
fi

hex_pattern=$(echo "$TEXT_INPUT" | grep -o '[0-9a-fA-F]\+' | head -1)
if [[ -n "$hex_pattern" && ${#hex_pattern} -ge 2 && $((${#hex_pattern} % 2)) -eq 0 ]]; then
    echo "<strong>Hex pattern found:</strong> $hex_pattern<br>"
    hex_ascii=""
    for (( i=0; i<${#hex_pattern}; i+=2 )); do
        hex_byte="${hex_pattern:$i:2}"
        decimal=$((16#$hex_byte))
        if [[ $decimal -ge 32 && $decimal -le 126 ]]; then
            hex_ascii+=$(printf "\\$(printf '%03o' $decimal)")
        fi
    done
    if [[ -n "$hex_ascii" ]]; then
        echo "<strong>Hex as ASCII:</strong> $hex_ascii<br>"
    fi
fi
echo "</div>"
echo "</div>"

echo "<div class='analysis-section'>"
echo "<h5>📊 Analysis Summary:</h5>"
echo "<div class='summary-box'>"
echo "<strong>Text Statistics:</strong><br>"
echo "• Total characters: ${#TEXT_INPUT}<br>"
echo "• Total words: $(echo "$TEXT_INPUT" | wc -w)<br>"
echo "• Total lines: $(echo "$TEXT_INPUT" | wc -l)<br>"
echo "• Capital letters: ${#capitals}<br>"
echo "• Digits: ${#numbers}<br><br>"

echo "<strong>🔍 Investigation Tips:</strong><br>"
echo "• Look for patterns in first/last letters of words or lines<br>"
echo "• Check if capital letters spell something meaningful<br>"
echo "• Try different intervals for character extraction<br>"
echo "• Consider if numbers represent ASCII codes or coordinates<br>"
echo "• Check for invisible characters or Unicode steganography<br>"
echo "• Look for patterns in punctuation or spacing<br>"
echo "</div>"
echo "</div>"

echo "</div>"
echo "</div>"

EOF 