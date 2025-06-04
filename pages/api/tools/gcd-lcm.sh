#!/bin/bash

# GCD/LCM Calculator Tool

NUM1="${FORM_DATA["gcd-num1"]}"
NUM2="${FORM_DATA["gcd-num2"]}"

if [[ -z "$NUM1" || -z "$NUM2" ]]; then
    echo "<div class='tool-error'>Please enter both numbers</div>"
    exit 0
fi

if ! [[ "$NUM1" =~ ^[0-9]+$ ]] || ! [[ "$NUM2" =~ ^[0-9]+$ ]]; then
    echo "<div class='tool-error'>Please enter positive integers only</div>"
    exit 0
fi

if [[ "$NUM1" -eq 0 || "$NUM2" -eq 0 ]]; then
    echo "<div class='tool-error'>Numbers must be greater than 0</div>"
    exit 0
fi

echo "<div class='tool-result'>"
echo "<h4>GCD/LCM Calculator Results</h4>"
echo "<div class='math-results'>"

echo "<strong>Input Numbers:</strong><br>"
echo "<div class='number-display'>"
echo "<span class='number'>Number 1: $NUM1</span><br>"
echo "<span class='number'>Number 2: $NUM2</span>"
echo "</div><br>"

gcd_euclidean() {
    local a=$1
    local b=$2
    while [[ $b -ne 0 ]]; do
        local temp=$b
        b=$((a % b))
        a=$temp
    done
    echo $a
}

GCD=$(gcd_euclidean $NUM1 $NUM2)

LCM=$(( (NUM1 * NUM2) / GCD ))

echo "<strong>🔢 Results:</strong><br>"
echo "<div class='result-section'>"
echo "<div class='result-box gcd-result'>"
echo "<h5>Greatest Common Divisor (GCD)</h5>"
echo "<div class='result-value'>$GCD</div>"
echo "<div class='result-desc'>The largest positive integer that divides both numbers</div>"
echo "</div>"

echo "<div class='result-box lcm-result'>"
echo "<h5>Least Common Multiple (LCM)</h5>"
echo "<div class='result-value'>$LCM</div>"
echo "<div class='result-desc'>The smallest positive integer that both numbers divide</div>"
echo "</div>"
echo "</div>"

echo "<br><strong>📚 Step-by-step Euclidean Algorithm for GCD:</strong><br>"
echo "<div class='algorithm-steps'>"

a=$NUM1
b=$NUM2
step=1

echo "<div class='step-item'>"
echo "<strong>Initial:</strong> GCD($NUM1, $NUM2)"
echo "</div>"

while [[ $b -ne 0 ]]; do
    quotient=$((a / b))
    remainder=$((a % b))
    
    echo "<div class='step-item'>"
    echo "<strong>Step $step:</strong> $a = $b × $quotient + $remainder"
    echo "</div>"
    
    a=$b
    b=$remainder
    ((step++))
done

echo "<div class='step-item final-step'>"
echo "<strong>Final:</strong> GCD = $a (when remainder = 0)"
echo "</div>"
echo "</div>"

echo "<br><strong>🔍 Prime Factorization Analysis:</strong><br>"
echo "<div class='prime-analysis'>"

prime_factors() {
    local n=$1
    local factors=""
    local d=2
    
    while [[ $((d * d)) -le $n ]]; do
        while [[ $((n % d)) -eq 0 ]]; then
            if [[ -n "$factors" ]]; then
                factors="$factors × $d"
            else
                factors="$d"
            fi
            n=$((n / d))
        done
        ((d++))
    done
    
    if [[ $n -gt 1 ]]; then
        if [[ -n "$factors" ]]; then
            factors="$factors × $n"
        else
            factors="$n"
        fi
    fi
    
    echo "$factors"
}

factors1=$(prime_factors $NUM1)
factors2=$(prime_factors $NUM2)

echo "<div class='factorization-box'>"
echo "<strong>$NUM1 =</strong> $factors1<br>"
echo "<strong>$NUM2 =</strong> $factors2"
echo "</div>"
echo "</div>"

echo "<br><strong>📊 Number Relationship Analysis:</strong><br>"
echo "<div class='relationship-analysis'>"

echo "<div class='relationship-item'>"
echo "<strong>GCD × LCM =</strong> $((GCD * LCM)) = $NUM1 × $NUM2 = $((NUM1 * NUM2))"
echo "<div class='formula-note'>✓ This confirms our calculations (GCD × LCM = Product of numbers)</div>"
echo "</div>"

if [[ $GCD -eq 1 ]]; then
    echo "<div class='relationship-item coprime'>"
    echo "<strong>Special Property:</strong> Numbers are coprime (relatively prime)"
    echo "<div class='formula-note'>GCD = 1 means the numbers share no common factors except 1</div>"
    echo "</div>"
fi

if [[ $((NUM1 % NUM2)) -eq 0 ]]; then
    echo "<div class='relationship-item divisible'>"
    echo "<strong>Special Property:</strong> $NUM1 is divisible by $NUM2"
    echo "<div class='formula-note'>GCD = $NUM2, LCM = $NUM1</div>"
    echo "</div>"
elif [[ $((NUM2 % NUM1)) -eq 0 ]]; then
    echo "<div class='relationship-item divisible'>"
    echo "<strong>Special Property:</strong> $NUM2 is divisible by $NUM1"
    echo "<div class='formula-note'>GCD = $NUM1, LCM = $NUM2</div>"
    echo "</div>"
fi

echo "</div>"

echo "<br><strong>🔧 Practical Applications:</strong><br>"
echo "<div class='applications'>"
echo "<div class='app-item'>"
echo "<strong>Fraction Simplification:</strong> $NUM1/$NUM2 = $((NUM1/GCD))/$((NUM2/GCD))"
echo "</div>"
echo "<div class='app-item'>"
echo "<strong>Common Denominators:</strong> Use LCM ($LCM) as common denominator"
echo "</div>"
echo "<div class='app-item'>"
echo "<strong>Gear Ratios:</strong> Every $LCM time units, patterns repeat"
echo "</div>"
echo "</div>"

echo "</div>"
echo "</div>"

EOF 