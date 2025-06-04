#!/bin/bash

# Prime Number Checker Tool

NUMBER="${FORM_DATA["prime-input"]}"

if [[ -z "$NUMBER" ]]; then
    echo "<div class='tool-error'>Please enter a number to check</div>"
    exit 0
fi

if ! [[ "$NUMBER" =~ ^[0-9]+$ ]]; then
    echo "<div class='tool-error'>Please enter a positive integer only</div>"
    exit 0
fi

if [[ "$NUMBER" -eq 0 || "$NUMBER" -eq 1 ]]; then
    echo "<div class='tool-error'>Please enter a number greater than 1</div>"
    exit 0
fi

echo "<div class='tool-result'>"
echo "<h4>Prime Number Analysis Results</h4>"
echo "<div class='prime-results'>"

echo "<strong>Input Number:</strong><br>"
echo "<div class='number-display'>"
echo "<span class='number'>$NUMBER</span>"
echo "</div><br>"

is_prime() {
    local n=$1
    if [[ $n -le 1 ]]; then
        return 1
    fi
    if [[ $n -le 3 ]]; then
        return 0
    fi
    if [[ $((n % 2)) -eq 0 || $((n % 3)) -eq 0 ]]; then
        return 1
    fi
    
    local i=5
    while [[ $((i * i)) -le $n ]]; do
        if [[ $((n % i)) -eq 0 || $((n % (i + 2))) -eq 0 ]]; then
            return 1
        fi
        i=$((i + 6))
    done
    return 0
}

find_factors() {
    local n=$1
    local factors=""
    local i=1
    
    while [[ $((i * i)) -le $n ]]; do
        if [[ $((n % i)) -eq 0 ]]; then
            if [[ -z "$factors" ]]; then
                factors="$i"
            else
                factors="$factors, $i"
            fi
            
            if [[ $((i * i)) -ne $n ]]; then
                factors="$factors, $((n / i))"
            fi
        fi
        ((i++))
    done
    
    echo "$factors" | tr ',' '\n' | sort -n | tr '\n' ',' | sed 's/,$//' | sed 's/,/, /g'
}

if is_prime $NUMBER; then
    PRIME_STATUS="YES"
    STATUS_CLASS="prime-yes"
    STATUS_ICON="✅"
else
    PRIME_STATUS="NO"
    STATUS_CLASS="prime-no"
    STATUS_ICON="❌"
fi

echo "<strong>🔍 Prime Analysis:</strong><br>"
echo "<div class='prime-status $STATUS_CLASS'>"
echo "<h5>$STATUS_ICON Is $NUMBER Prime?</h5>"
echo "<div class='status-answer'>$PRIME_STATUS</div>"
echo "</div>"

if [[ "$PRIME_STATUS" == "NO" ]]; then
    factors=$(find_factors $NUMBER)
    echo "<br><strong>🔢 Factors of $NUMBER:</strong><br>"
    echo "<div class='factors-display'>"
    echo "$factors"
    echo "</div>"
    
    echo "<br><strong>🔬 Prime Factorization:</strong><br>"
    echo "<div class='factorization-display'>"
    
    n=$NUMBER
    prime_factors=""
    d=2
    
    while [[ $((d * d)) -le $n ]]; do
        while [[ $((n % d)) -eq 0 ]]; do
            if [[ -z "$prime_factors" ]]; then
                prime_factors="$d"
            else
                prime_factors="$prime_factors × $d"
            fi
            n=$((n / d))
        done
        ((d++))
    done
    
    if [[ $n -gt 1 ]]; then
        if [[ -z "$prime_factors" ]]; then
            prime_factors="$n"
        else
            prime_factors="$prime_factors × $n"
        fi
    fi
    
    echo "<div class='factorization-result'>"
    echo "$NUMBER = $prime_factors"
    echo "</div>"
    echo "</div>"
else
    echo "<br><strong>🎉 Prime Properties:</strong><br>"
    echo "<div class='prime-properties'>"
    echo "<div class='property-item'>"
    echo "<strong>Factors:</strong> Only 1 and $NUMBER"
    echo "</div>"
    echo "<div class='property-item'>"
    echo "<strong>Divisibility:</strong> Not divisible by any number except 1 and itself"
    echo "</div>"
    echo "<div class='property-item'>"
    echo "<strong>Mathematical:</strong> Cannot be expressed as a product of smaller natural numbers"
    echo "</div>"
    echo "</div>"
fi

echo "<br><strong>📊 Number Classification:</strong><br>"
echo "<div class='classification-grid'>"

if [[ $((NUMBER % 2)) -eq 0 ]]; then
    echo "<div class='classification-item'>"
    echo "<strong>Parity:</strong> Even"
    echo "</div>"
else
    echo "<div class='classification-item'>"
    echo "<strong>Parity:</strong> Odd"
    echo "</div>"
fi

sqrt_n=$(echo "sqrt($NUMBER)" | bc 2>/dev/null | cut -d. -f1)
if [[ $((sqrt_n * sqrt_n)) -eq $NUMBER ]]; then
    echo "<div class='classification-item'>"
    echo "<strong>Perfect Square:</strong> Yes ($sqrt_n²)"
    echo "</div>"
else
    echo "<div class='classification-item'>"
    echo "<strong>Perfect Square:</strong> No"
    echo "</div>"
fi

fib_check() {
    local n=$1
    local a=0
    local b=1
    
    if [[ $n -eq 0 || $n -eq 1 ]]; then
        return 0
    fi
    
    while [[ $b -lt $n ]]; do
        local temp=$((a + b))
        a=$b
        b=$temp
    done
    
    [[ $b -eq $n ]]
}

if fib_check $NUMBER; then
    echo "<div class='classification-item'>"
    echo "<strong>Fibonacci Number:</strong> Yes"
    echo "</div>"
else
    echo "<div class='classification-item'>"
    echo "<strong>Fibonacci Number:</strong> No"
    echo "</div>"
fi

echo "</div>"

echo "<br><strong>🔗 Related Prime Information:</strong><br>"
echo "<div class='related-primes'>"

find_next_prime() {
    local start=$((NUMBER + 1))
    while true; do
        if is_prime $start; then
            echo $start
            return
        fi
        ((start++))
        if [[ $start -gt $((NUMBER + 1000)) ]]; then
            echo ">"
            return
        fi
    done
}

find_prev_prime() {
    local start=$((NUMBER - 1))
    while [[ $start -gt 1 ]]; do
        if is_prime $start; then
            echo $start
            return
        fi
        ((start--))
    done
    echo "None"
}

next_prime=$(find_next_prime)
prev_prime=$(find_prev_prime)

echo "<div class='related-item'>"
echo "<strong>Previous Prime:</strong> $prev_prime"
echo "</div>"

echo "<div class='related-item'>"
echo "<strong>Next Prime:</strong> $next_prime"
echo "</div>"

if [[ "$PRIME_STATUS" == "YES" ]]; then
    if [[ $((NUMBER + 2)) != "$next_prime" ]] && is_prime $((NUMBER + 2)); then
        echo "<div class='related-item special'>"
        echo "<strong>Twin Prime:</strong> Yes (with $((NUMBER + 2)))"
        echo "</div>"
    elif [[ $((NUMBER - 2)) == "$prev_prime" ]]; then
        echo "<div class='related-item special'>"
        echo "<strong>Twin Prime:</strong> Yes (with $((NUMBER - 2)))"
        echo "</div>"
    fi
    
    if [[ $NUMBER -gt 1 ]]; then
        mersenne_check=$((NUMBER + 1))
        power=1
        while [[ $((2 ** power)) -le $mersenne_check ]]; do
            if [[ $((2 ** power)) -eq $mersenne_check ]]; then
                echo "<div class='related-item special'>"
                echo "<strong>Mersenne Prime:</strong> $NUMBER = 2^$power - 1"
                echo "</div>"
                break
            fi
            ((power++))
        done
    fi
fi

echo "</div>"

echo "<br><strong>🎲 Fun Facts:</strong><br>"
echo "<div class='fun-facts'>"

echo "<div class='fact-item'>"
echo "<strong>Binary:</strong> $(echo "obase=2; $NUMBER" | bc)"
echo "</div>"

echo "<div class='fact-item'>"
echo "<strong>Hexadecimal:</strong> $(echo "obase=16; $NUMBER" | bc)"
echo "</div>"

echo "<div class='fact-item'>"
echo "<strong>Sum of digits:</strong> $(echo $NUMBER | fold -w1 | paste -sd+ | bc)"
echo "</div>"

if [[ "$PRIME_STATUS" == "YES" ]]; then
    echo "<div class='fact-item special'>"
    echo "<strong>Prime position:</strong> $NUMBER is a prime number!"
    echo "</div>"
fi

echo "</div>"

echo "</div>"
echo "</div>"

EOF 