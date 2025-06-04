#!/bin/bash

# Number Base Converter Tool

NUMBER="${FORM_DATA["base-input"]}"
FROM_BASE="${FORM_DATA["base-from"]}"

if [[ -z "$NUMBER" ]]; then
    echo "<div class='tool-error'>Please enter a number to convert</div>"
    exit 0
fi

CLEAN_NUMBER=$(echo "$NUMBER" | tr -d ' ' | tr '[:lower:]' '[:upper:]')

validate_input() {
    local num="$1"
    local base="$2"
    
    case $base in
        2)  # Binary
            if [[ ! "$num" =~ ^[01]+$ ]]; then
                return 1
            fi
            ;;
        8)  # Octal
            if [[ ! "$num" =~ ^[0-7]+$ ]]; then
                return 1
            fi
            ;;
        10) # Decimal
            if [[ ! "$num" =~ ^[0-9]+$ ]]; then
                return 1
            fi
            ;;
        16) # Hexadecimal
            if [[ ! "$num" =~ ^[0-9A-F]+$ ]]; then
                return 1
            fi
            ;;
        *)
            return 1
            ;;
    esac
    return 0
}

convert_to_decimal() {
    local num="$1"
    local base="$2"
    
    case $base in
        2)  echo $((2#$num)) ;;
        8)  echo $((8#$num)) ;;
        10) echo $num ;;
        16) echo $((16#$num)) ;;
    esac
}

decimal_to_binary() {
    local num=$1
    local result=""
    
    if [[ $num -eq 0 ]]; then
        echo "0"
        return
    fi
    
    while [[ $num -gt 0 ]]; do
        result="$((num % 2))$result"
        num=$((num / 2))
    done
    
    echo "$result"
}

decimal_to_octal() {
    local num=$1
    local result=""
    
    if [[ $num -eq 0 ]]; then
        echo "0"
        return
    fi
    
    while [[ $num -gt 0 ]]; do
        result="$((num % 8))$result"
        num=$((num / 8))
    done
    
    echo "$result"
}

decimal_to_hex() {
    local num=$1
    local result=""
    local hex_chars="0123456789ABCDEF"
    
    if [[ $num -eq 0 ]]; then
        echo "0"
        return
    fi
    
    while [[ $num -gt 0 ]]; do
        local remainder=$((num % 16))
        result="${hex_chars:$remainder:1}$result"
        num=$((num / 16))
    done
    
    echo "$result"
}

echo "<div class='tool-result'>"
echo "<h4>Number Base Converter Results</h4>"
echo "<div class='converter-results'>"

if validate_input "$CLEAN_NUMBER" "$FROM_BASE"; then
    decimal_value=$(convert_to_decimal "$CLEAN_NUMBER" "$FROM_BASE")
    
    echo "<strong>Input:</strong><br>"
    echo "<div class='input-display'>"
    echo "Number: <code class='number-display'>$CLEAN_NUMBER</code><br>"
    
    case $FROM_BASE in
        2)  echo "Base: Binary (2)" ;;
        8)  echo "Base: Octal (8)" ;;
        10) echo "Base: Decimal (10)" ;;
        16) echo "Base: Hexadecimal (16)" ;;
    esac
    echo "</div><br>"
    
    echo "<strong>Conversions:</strong><br>"
    echo "<div class='conversion-grid'>"
    
    binary_value=$(decimal_to_binary $decimal_value)
    echo "<div class='conversion-item binary'>"
    echo "<h5>Binary (Base 2)</h5>"
    echo "<code class='converted-number'>$binary_value</code>"
    echo "<div class='conversion-info'>Used in: Computer science, digital systems</div>"
    echo "</div>"
    
    octal_value=$(decimal_to_octal $decimal_value)
    echo "<div class='conversion-item octal'>"
    echo "<h5>Octal (Base 8)</h5>"
    echo "<code class='converted-number'>$octal_value</code>"
    echo "<div class='conversion-info'>Used in: Unix file permissions, some programming</div>"
    echo "</div>"
    
    echo "<div class='conversion-item decimal'>"
    echo "<h5>Decimal (Base 10)</h5>"
    echo "<code class='converted-number'>$decimal_value</code>"
    echo "<div class='conversion-info'>Used in: Everyday mathematics, human counting</div>"
    echo "</div>"
    
    hex_value=$(decimal_to_hex $decimal_value)
    echo "<div class='conversion-item hexadecimal'>"
    echo "<h5>Hexadecimal (Base 16)</h5>"
    echo "<code class='converted-number'>$hex_value</code>"
    echo "<div class='conversion-info'>Used in: Programming, memory addresses, colors</div>"
    echo "</div>"
    
    echo "</div>"
    
    echo "<br><strong>Additional Information:</strong><br>"
    echo "<div class='additional-info'>"
    
    if [[ $FROM_BASE -eq 2 ]] || [[ $decimal_value -lt 256 ]]; then
        bit_length=${#binary_value}
        echo "🔢 <strong>Bit Analysis:</strong><br>"
        echo "• Bit length: $bit_length bits<br>"
        
        if [[ $decimal_value -le 255 ]]; then
            echo "• Fits in: 8-bit byte<br>"
        elif [[ $decimal_value -le 65535 ]]; then
            echo "• Fits in: 16-bit word<br>"
        elif [[ $decimal_value -le 4294967295 ]]; then
            echo "• Fits in: 32-bit dword<br>"
        fi
    fi
    
    if [[ $decimal_value -gt 0 ]]; then
        if [[ $((decimal_value & (decimal_value - 1))) -eq 0 ]]; then
            power_of_2=0
            temp_val=$decimal_value
            while [[ $temp_val -gt 1 ]]; do
                temp_val=$((temp_val / 2))
                power_of_2=$((power_of_2 + 1))
            done
            echo "⚡ <strong>Special Number:</strong> This is 2^$power_of_2<br>"
        fi
    fi
    
    echo "<br>💻 <strong>Programming Representations:</strong><br>"
    echo "• C/C++: 0x$hex_value (hex), 0$octal_value (octal), 0b$binary_value (binary)<br>"
    echo "• Python: 0x$hex_value (hex), 0o$octal_value (octal), 0b$binary_value (binary)<br>"
    echo "• JavaScript: 0x$hex_value (hex), 0o$octal_value (octal), 0b$binary_value (binary)<br>"
    
    if [[ $decimal_value -le 16777215 ]] && [[ $decimal_value -ge 0 ]]; then
        color_hex=$(printf "%06X" $decimal_value)
        echo "<br>🎨 <strong>Color Representation:</strong><br>"
        echo "• CSS Color: #$color_hex"
        echo "<div class='color-preview' style='background-color: #$color_hex; width: 50px; height: 20px; border: 1px solid var(--border-color); display: inline-block; margin-left: 10px;'></div><br>"
    fi
    
    echo "</div>"
    
else
    echo "<div class='tool-error'>"
    echo "❌ <strong>Invalid Input</strong><br><br>"
    echo "The number '$CLEAN_NUMBER' is not valid for base $FROM_BASE.<br><br>"
    
    echo "<strong>Valid characters for each base:</strong><br>"
    echo "• Binary (2): 0, 1<br>"
    echo "• Octal (8): 0, 1, 2, 3, 4, 5, 6, 7<br>"
    echo "• Decimal (10): 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br>"
    echo "• Hexadecimal (16): 0-9, A-F<br>"
    echo "</div>"
fi

echo "</div>"
echo "</div>"