#!/bin/bash

# Caesar Cipher Decoder Tool

TEXT="${FORM_DATA["caesar-input"]}"
ROTATION="${FORM_DATA["caesar-rotation"]}"

if [[ -z "$TEXT" ]]; then
    echo "<div class='tool-error'>Please enter text to decode</div>"
    exit 0
fi

decode_caesar() {
    local text="$1"
    local shift="$2"
    local result=""
    
    for (( i=0; i<${#text}; i++ )); do
        char="${text:$i:1}"
        
        if [[ $char =~ [A-Z] ]]; then
            ascii_val=$(printf '%d' "'$char")
            new_val=$(( (ascii_val - 65 - shift + 26) % 26 + 65 ))
            new_char=$(printf "\\$(printf '%03o' $new_val)")
            result+="$new_char"
        elif [[ $char =~ [a-z] ]]; then
            ascii_val=$(printf '%d' "'$char")
            new_val=$(( (ascii_val - 97 - shift + 26) % 26 + 97 ))
            new_char=$(printf "\\$(printf '%03o' $new_val)")
            result+="$new_char"
        else
            result+="$char"
        fi
    done
    
    echo "$result"
}

echo "<div class='tool-result'>"
echo "<h4>Caesar Cipher Decoder Results</h4>"
echo "<div class='caesar-results'>"

if [[ -n "$ROTATION" ]] && [[ "$ROTATION" =~ ^[0-9]+$ ]] && [[ "$ROTATION" -ge 1 ]] && [[ "$ROTATION" -le 25 ]]; then
    echo "<strong>Original Text:</strong><br>"
    echo "<div class='text-box'>$TEXT</div><br>"
    
    echo "<strong>Decoded with ROT$ROTATION:</strong><br>"
    decoded=$(decode_caesar "$TEXT" "$ROTATION")
    echo "<div class='text-box decoded-text'>$decoded</div><br>"
    
    echo "<strong>Pattern Analysis:</strong><br>"
    
    score=0
    text_lower=$(echo "$decoded" | tr '[:upper:]' '[:lower:]')
    
    if [[ "$text_lower" =~ hello ]]; then ((score+=5)); fi
    if [[ "$text_lower" =~ world ]]; then ((score+=5)); fi
    if [[ "$text_lower" =~ [^a-z]the[^a-z] ]] || [[ "$text_lower" =~ ^the[^a-z] ]] || [[ "$text_lower" =~ [^a-z]the$ ]]; then ((score+=4)); fi
    if [[ "$text_lower" =~ [^a-z]and[^a-z] ]] || [[ "$text_lower" =~ ^and[^a-z] ]] || [[ "$text_lower" =~ [^a-z]and$ ]]; then ((score+=3)); fi
    if [[ "$text_lower" =~ [^a-z]flag[^a-z] ]] || [[ "$text_lower" =~ ^flag[^a-z] ]] || [[ "$text_lower" =~ [^a-z]flag$ ]]; then ((score+=5)); fi
    if [[ "$text_lower" =~ [^a-z]you[^a-z] ]] || [[ "$text_lower" =~ ^you[^a-z] ]] || [[ "$text_lower" =~ [^a-z]you$ ]]; then ((score+=3)); fi
    if [[ "$text_lower" =~ [^a-z]are[^a-z] ]] || [[ "$text_lower" =~ ^are[^a-z] ]] || [[ "$text_lower" =~ [^a-z]are$ ]]; then ((score+=2)); fi
    if [[ "$text_lower" =~ [^a-z]this[^a-z] ]] || [[ "$text_lower" =~ ^this[^a-z] ]] || [[ "$text_lower" =~ [^a-z]this$ ]]; then ((score+=2)); fi
    if [[ "$text_lower" =~ [^a-z]that[^a-z] ]] || [[ "$text_lower" =~ ^that[^a-z] ]] || [[ "$text_lower" =~ [^a-z]that$ ]]; then ((score+=2)); fi
    if [[ "$text_lower" =~ [^a-z]with[^a-z] ]] || [[ "$text_lower" =~ ^with[^a-z] ]] || [[ "$text_lower" =~ [^a-z]with$ ]]; then ((score+=2)); fi
    if [[ "$text_lower" =~ [^a-z]have[^a-z] ]] || [[ "$text_lower" =~ ^have[^a-z] ]] || [[ "$text_lower" =~ [^a-z]have$ ]]; then ((score+=2)); fi
    if [[ "$text_lower" =~ [^a-z]for[^a-z] ]] || [[ "$text_lower" =~ ^for[^a-z] ]] || [[ "$text_lower" =~ [^a-z]for$ ]]; then ((score+=2)); fi
    if [[ "$text_lower" =~ [^a-z]not[^a-z] ]] || [[ "$text_lower" =~ ^not[^a-z] ]] || [[ "$text_lower" =~ [^a-z]not$ ]]; then ((score+=2)); fi
    if [[ "$text_lower" =~ [^a-z]can[^a-z] ]] || [[ "$text_lower" =~ ^can[^a-z] ]] || [[ "$text_lower" =~ [^a-z]can$ ]]; then ((score+=2)); fi
    if [[ "$text_lower" =~ [^a-z]but[^a-z] ]] || [[ "$text_lower" =~ ^but[^a-z] ]] || [[ "$text_lower" =~ [^a-z]but$ ]]; then ((score+=2)); fi
    if [[ "$text_lower" =~ [^a-z]all[^a-z] ]] || [[ "$text_lower" =~ ^all[^a-z] ]] || [[ "$text_lower" =~ [^a-z]all$ ]]; then ((score+=2)); fi
    if [[ "$text_lower" =~ [^a-z]was[^a-z] ]] || [[ "$text_lower" =~ ^was[^a-z] ]] || [[ "$text_lower" =~ [^a-z]was$ ]]; then ((score+=2)); fi
    if [[ "$text_lower" =~ [^a-z]his[^a-z] ]] || [[ "$text_lower" =~ ^his[^a-z] ]] || [[ "$text_lower" =~ [^a-z]his$ ]]; then ((score+=2)); fi
    if [[ "$text_lower" =~ [^a-z]her[^a-z] ]] || [[ "$text_lower" =~ ^her[^a-z] ]] || [[ "$text_lower" =~ [^a-z]her$ ]]; then ((score+=2)); fi
    if [[ "$text_lower" =~ [^a-z]she[^a-z] ]] || [[ "$text_lower" =~ ^she[^a-z] ]] || [[ "$text_lower" =~ [^a-z]she$ ]]; then ((score+=2)); fi
    if [[ "$text_lower" =~ [^a-z]out[^a-z] ]] || [[ "$text_lower" =~ ^out[^a-z] ]] || [[ "$text_lower" =~ [^a-z]out$ ]]; then ((score+=2)); fi
    
    vowel_count=$(echo "$decoded" | grep -o -i '[aeiou]' | wc -l)
    consonant_count=$(echo "$decoded" | grep -o -i '[bcdfghjklmnpqrstvwxyz]' | wc -l)
    total_chars=$(echo "$decoded" | grep -o '[a-zA-Z]' | wc -l)
    
    if [[ $total_chars -gt 0 ]]; then
        vowel_ratio=$((vowel_count * 100 / total_chars))
        if [[ $vowel_ratio -ge 25 ]] && [[ $vowel_ratio -le 60 ]]; then
            ((score+=3))
        fi
        
        if ! echo "$text_lower" | grep -q '[bcdfghjklmnpqrstvwxyz]\{5,\}'; then
            ((score+=2))
        fi
        
        if echo "$text_lower" | grep -q '[etaoinshrdlu]'; then
            ((score+=1))
        fi
    fi
    
    if [[ $score -ge 7 ]]; then
        echo "✅ <span class='pattern-good'>Highly likely to be readable English text</span><br>"
    elif [[ $score -ge 4 ]]; then
        echo "✅ <span class='pattern-good'>Likely contains readable English text</span><br>"
    elif [[ $score -ge 2 ]]; then
        echo "🟡 <span class='pattern-maybe'>Possibly readable English - check carefully</span><br>"
    else
        echo "❓ <span class='pattern-maybe'>May not be readable English - try other rotations</span><br>"
    fi
    
else
    echo "<strong>Original Text:</strong><br>"
    echo "<div class='text-box'>$TEXT</div><br>"
    
    echo "<strong>All Possible Rotations:</strong><br>"
    echo "<div class='rotation-grid'>"
    
    for rot in {1..25}; do
        decoded=$(decode_caesar "$TEXT" "$rot")
        
        score=0
        text_lower=$(echo "$decoded" | tr '[:upper:]' '[:lower:]')
        
        if [[ "$text_lower" =~ hello ]]; then ((score+=5)); fi
        if [[ "$text_lower" =~ world ]]; then ((score+=5)); fi
        if [[ "$text_lower" =~ [^a-z]the[^a-z] ]] || [[ "$text_lower" =~ ^the[^a-z] ]] || [[ "$text_lower" =~ [^a-z]the$ ]]; then ((score+=4)); fi
        if [[ "$text_lower" =~ [^a-z]and[^a-z] ]] || [[ "$text_lower" =~ ^and[^a-z] ]] || [[ "$text_lower" =~ [^a-z]and$ ]]; then ((score+=3)); fi
        if [[ "$text_lower" =~ [^a-z]flag[^a-z] ]] || [[ "$text_lower" =~ ^flag[^a-z] ]] || [[ "$text_lower" =~ [^a-z]flag$ ]]; then ((score+=5)); fi
        if [[ "$text_lower" =~ [^a-z]you[^a-z] ]] || [[ "$text_lower" =~ ^you[^a-z] ]] || [[ "$text_lower" =~ [^a-z]you$ ]]; then ((score+=3)); fi
        if [[ "$text_lower" =~ [^a-z]are[^a-z] ]] || [[ "$text_lower" =~ ^are[^a-z] ]] || [[ "$text_lower" =~ [^a-z]are$ ]]; then ((score+=2)); fi
        if [[ "$text_lower" =~ [^a-z]this[^a-z] ]] || [[ "$text_lower" =~ ^this[^a-z] ]] || [[ "$text_lower" =~ [^a-z]this$ ]]; then ((score+=2)); fi
        if [[ "$text_lower" =~ [^a-z]that[^a-z] ]] || [[ "$text_lower" =~ ^that[^a-z] ]] || [[ "$text_lower" =~ [^a-z]that$ ]]; then ((score+=2)); fi
        if [[ "$text_lower" =~ [^a-z]with[^a-z] ]] || [[ "$text_lower" =~ ^with[^a-z] ]] || [[ "$text_lower" =~ [^a-z]with$ ]]; then ((score+=2)); fi
        if [[ "$text_lower" =~ [^a-z]have[^a-z] ]] || [[ "$text_lower" =~ ^have[^a-z] ]] || [[ "$text_lower" =~ [^a-z]have$ ]]; then ((score+=2)); fi
        if [[ "$text_lower" =~ [^a-z]for[^a-z] ]] || [[ "$text_lower" =~ ^for[^a-z] ]] || [[ "$text_lower" =~ [^a-z]for$ ]]; then ((score+=2)); fi
        if [[ "$text_lower" =~ [^a-z]not[^a-z] ]] || [[ "$text_lower" =~ ^not[^a-z] ]] || [[ "$text_lower" =~ [^a-z]not$ ]]; then ((score+=2)); fi
        if [[ "$text_lower" =~ [^a-z]can[^a-z] ]] || [[ "$text_lower" =~ ^can[^a-z] ]] || [[ "$text_lower" =~ [^a-z]can$ ]]; then ((score+=2)); fi
        if [[ "$text_lower" =~ [^a-z]but[^a-z] ]] || [[ "$text_lower" =~ ^but[^a-z] ]] || [[ "$text_lower" =~ [^a-z]but$ ]]; then ((score+=2)); fi
        if [[ "$text_lower" =~ [^a-z]all[^a-z] ]] || [[ "$text_lower" =~ ^all[^a-z] ]] || [[ "$text_lower" =~ [^a-z]all$ ]]; then ((score+=2)); fi
        if [[ "$text_lower" =~ [^a-z]was[^a-z] ]] || [[ "$text_lower" =~ ^was[^a-z] ]] || [[ "$text_lower" =~ [^a-z]was$ ]]; then ((score+=2)); fi
        if [[ "$text_lower" =~ [^a-z]his[^a-z] ]] || [[ "$text_lower" =~ ^his[^a-z] ]] || [[ "$text_lower" =~ [^a-z]his$ ]]; then ((score+=2)); fi
        if [[ "$text_lower" =~ [^a-z]her[^a-z] ]] || [[ "$text_lower" =~ ^her[^a-z] ]] || [[ "$text_lower" =~ [^a-z]her$ ]]; then ((score+=2)); fi
        if [[ "$text_lower" =~ [^a-z]she[^a-z] ]] || [[ "$text_lower" =~ ^she[^a-z] ]] || [[ "$text_lower" =~ [^a-z]she$ ]]; then ((score+=2)); fi
        if [[ "$text_lower" =~ [^a-z]out[^a-z] ]] || [[ "$text_lower" =~ ^out[^a-z] ]] || [[ "$text_lower" =~ [^a-z]out$ ]]; then ((score+=2)); fi
        
        vowel_count=$(echo "$decoded" | grep -o -i '[aeiou]' | wc -l)
        total_chars=$(echo "$decoded" | grep -o '[a-zA-Z]' | wc -l)
        
        if [[ $total_chars -gt 0 ]]; then
            vowel_ratio=$((vowel_count * 100 / total_chars))
            if [[ $vowel_ratio -ge 25 ]] && [[ $vowel_ratio -le 60 ]]; then
                ((score+=3))
            fi
            
            if ! echo "$text_lower" | grep -q '[bcdfghjklmnpqrstvwxyz]\{5,\}'; then
                ((score+=2))
            fi
            
            if echo "$text_lower" | grep -q '[etaoinshrdlu]'; then
                ((score+=1))
            fi
        fi
        
        class=""
        if [[ $score -ge 8 ]]; then
            class="high-score"
        elif [[ $score -ge 5 ]]; then
            class="medium-score"
        fi
        
        echo "<div class='rotation-item $class'>"
        echo "<strong>ROT$rot:</strong> <span class='score'>(score: $score)</span><br>"
        echo "<div class='decoded-text'>$decoded</div>"
        echo "</div>"
    done
    
    echo "</div>"
    
    echo "<br><strong>Legend:</strong><br>"
    echo "🟢 <span class='high-score'>High Score</span> - Likely readable English<br>"
    echo "🟡 <span class='medium-score'>Medium Score</span> - Possibly readable<br>"
    echo "⚪ Low Score - Unlikely to be readable English<br>"
fi

echo "</div>"
echo "</div>"