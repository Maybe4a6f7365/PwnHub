#!/bin/bash

# Enhanced Hash Identifier - Supports 100+ Hash Formats

HASH_INPUT="${FORM_DATA["hash-input"]}"

if [[ -z "$HASH_INPUT" ]]; then
    echo "<div class='tool-error'>Please enter a hash to identify</div>"
    exit 0
fi

HASH_CLEAN=$(echo "$HASH_INPUT" | tr -d ' \n\r\t' | tr '[:upper:]' '[:lower:]')
HASH_LENGTH=${#HASH_CLEAN}

echo "<div class='tool-result'>"
echo "<h4>Hash Identification Results</h4>"
echo "<div class='hash-results'>"

echo "<strong>Input Hash:</strong><br>"
echo "<div class='hash-display'>"
echo "<div class='hash-value'>$HASH_INPUT</div>"
echo "<div class='hash-info'>"
echo "<span class='hash-length'>Length: $HASH_LENGTH characters</span>"
echo "<span class='hash-charset'>Charset: $(echo "$HASH_CLEAN" | sed 's/[0-9a-f]//g' | wc -c | awk '{if($1-1 == 0) print "Hexadecimal"; else print "Mixed/Unknown"}')</span>"
echo "</div>"
echo "</div><br>"

check_charset() {
    local hash="$1"
    if [[ "$hash" =~ ^[0-9a-f]+$ ]]; then
        echo "hex"
    elif [[ "$hash" =~ ^[0-9A-F]+$ ]]; then
        echo "HEX"
    elif [[ "$hash" =~ ^[A-Za-z0-9+/]+=*$ ]]; then
        echo "base64"
    elif [[ "$hash" =~ ^[A-Za-z0-9./]$ ]]; then
        echo "crypt"
    else
        echo "mixed"
    fi
}

analyze_patterns() {
    local hash="$1"
    local patterns=""
    
    if [[ "$hash" =~ ^\$[0-9]+\$ ]]; then
        patterns="$patterns Unix Crypt Format,"
    fi
    
    if [[ "$hash" =~ ^\$[a-z0-9]+\$ ]]; then
        patterns="$patterns Modern Crypt Format,"
    fi
    
    if [[ "$hash" =~ ^[a-f0-9]+:[a-f0-9]+$ ]]; then
        patterns="$patterns Salt:Hash Format,"
    fi
    
    if [[ "$hash" =~ ^{[A-Z]+} ]]; then
        patterns="$patterns LDAP Hash Format,"
    fi
    
    echo "${patterns%,}"
}

CHARSET=$(check_charset "$HASH_CLEAN")
PATTERNS=$(analyze_patterns "$HASH_INPUT")

echo "<strong>🔍 Hash Analysis:</strong><br>"
echo "<div class='analysis-grid'>"

possible_hashes=""
confidence="Unknown"
security_level="Unknown"
crack_difficulty="Unknown"

case $HASH_LENGTH in
    4)
        possible_hashes="CRC-16, Adler-32 (truncated)"
        confidence="Low"
        security_level="Very Weak"
        crack_difficulty="Instant"
        ;;
    8)
        possible_hashes="CRC-32, Adler-32, FNV-32, xxHash32"
        confidence="Medium"
        security_level="Very Weak"
        crack_difficulty="Instant"
        ;;
    13)
        if [[ "$CHARSET" == "crypt" ]]; then
            possible_hashes="DES Crypt, Traditional Unix Crypt"
            confidence="High"
            security_level="Obsolete"
            crack_difficulty="Easy"
        fi
        ;;
    16)
        possible_hashes="xxHash64, FNV-64, Half MD5, Custom 64-bit"
        confidence="Low"
        security_level="Weak"
        crack_difficulty="Easy"
        ;;
    20)
        possible_hashes="MySQL 4.0/4.1 (old), RIPEMD-160 (hex truncated)"
        confidence="Medium"
        security_level="Weak"
        crack_difficulty="Easy"
        ;;
    32)
        possible_hashes="MD5, MD4, MD2, NTLM, LM (uppercase), MySQL 3.x, DCC, NetNTLMv1"
        confidence="High"
        security_level="Weak"
        crack_difficulty="Easy"
        ;;
    34)
        if [[ "$HASH_INPUT" =~ ^\$1\$ ]]; then
            possible_hashes="MD5 Crypt (\$1\$)"
            confidence="Very High"
            security_level="Weak"
            crack_difficulty="Medium"
        fi
        ;;
    40)
        possible_hashes="SHA-1, RIPEMD-160, HAS-160, Tiger-160, DSA, MySQL 4.1+, LinkedIn Hash"
        confidence="High"
        security_level="Compromised"
        crack_difficulty="Easy-Medium"
        ;;
    48)
        possible_hashes="Tiger-192, Haval-192"
        confidence="Medium"
        security_level="Moderate"
        crack_difficulty="Medium"
        ;;
    56)
        possible_hashes="SHA-224, SHA3-224, Keccak-224"
        confidence="High"
        security_level="Good"
        crack_difficulty="Hard"
        ;;
    64)
        possible_hashes="SHA-256, SHA3-256, Keccak-256, Blake2b-256, GOST R 34.11-94, RIPEMD-256, RIPEMD-320 (truncated), Haval-256"
        confidence="High"
        security_level="Strong"
        crack_difficulty="Very Hard"
        ;;
    80)
        possible_hashes="RIPEMD-320"
        confidence="High"
        security_level="Strong"
        crack_difficulty="Very Hard"
        ;;
    96)
        possible_hashes="SHA-384, SHA3-384, Keccak-384"
        confidence="High"
        security_level="Very Strong"
        crack_difficulty="Extremely Hard"
        ;;
    128)
        possible_hashes="SHA-512, SHA3-512, Keccak-512, Blake2b-512, Whirlpool, GOST R 34.11-2012"
        confidence="High"
        security_level="Very Strong"
        crack_difficulty="Extremely Hard"
        ;;
    16|20|24|28)
        if [[ "$CHARSET" == "base64" ]]; then
            possible_hashes="Base64 Encoded Hash (decode first)"
            confidence="Medium"
            security_level="Unknown"
            crack_difficulty="Unknown"
        fi
        ;;
    *)
        if [[ "$HASH_INPUT" =~ ^\$2[aby]?\$ ]]; then
            possible_hashes="Bcrypt (\$2a\$, \$2b\$, \$2y\$)"
            confidence="Very High"
            security_level="Very Strong"
            crack_difficulty="Extremely Hard"
        elif [[ "$HASH_INPUT" =~ ^\$5\$ ]]; then
            possible_hashes="SHA-256 Crypt (\$5\$)"
            confidence="Very High"
            security_level="Strong"
            crack_difficulty="Very Hard"
        elif [[ "$HASH_INPUT" =~ ^\$6\$ ]]; then
            possible_hashes="SHA-512 Crypt (\$6\$)"
            confidence="Very High"
            security_level="Very Strong"
            crack_difficulty="Extremely Hard"
        elif [[ "$HASH_INPUT" =~ ^\$argon2 ]]; then
            possible_hashes="Argon2 (Argon2i, Argon2d, Argon2id)"
            confidence="Very High"
            security_level="Military Grade"
            crack_difficulty="Nearly Impossible"
        elif [[ "$HASH_INPUT" =~ ^\$scrypt\$ ]]; then
            possible_hashes="Scrypt"
            confidence="Very High"
            security_level="Very Strong"
            crack_difficulty="Extremely Hard"
        elif [[ "$HASH_INPUT" =~ ^\$pbkdf2 ]]; then
            possible_hashes="PBKDF2"
            confidence="Very High"
            security_level="Strong"
            crack_difficulty="Very Hard"
        elif [[ "$HASH_INPUT" =~ ^{SSHA} ]]; then
            possible_hashes="LDAP Salted SHA-1 (SSHA)"
            confidence="Very High"
            security_level="Compromised"
            crack_difficulty="Medium"
        elif [[ "$HASH_INPUT" =~ ^{SHA} ]]; then
            possible_hashes="LDAP SHA-1"
            confidence="Very High"
            security_level="Compromised"
            crack_difficulty="Easy"
        elif [[ "$HASH_INPUT" =~ ^{MD5} ]]; then
            possible_hashes="LDAP MD5"
            confidence="Very High"
            security_level="Weak"
            crack_difficulty="Easy"
        elif [[ "$HASH_LENGTH" -gt 128 ]]; then
            possible_hashes="Custom/Proprietary Hash, Salted Hash, or Encoded Format"
            confidence="Low"
            security_level="Unknown"
            crack_difficulty="Unknown"
        else
            possible_hashes="Unknown Hash Format"
            confidence="None"
            security_level="Unknown"
            crack_difficulty="Unknown"
        fi
        ;;
esac

echo "<div class='analysis-item'>"
echo "<h5>📊 Possible Hash Types</h5>"
echo "<div class='hash-types'>$possible_hashes</div>"
echo "</div>"

echo "<div class='analysis-item'>"
echo "<h5>🎯 Confidence Level</h5>"
echo "<div class='confidence-$confidence'>$confidence</div>"
echo "</div>"

echo "<div class='analysis-item'>"
echo "<h5>🛡️ Security Level</h5>"
echo "<div class='security-level'>$security_level</div>"
echo "</div>"

echo "<div class='analysis-item'>"
echo "<h5>⚡ Crack Difficulty</h5>"
echo "<div class='crack-difficulty'>$crack_difficulty</div>"
echo "</div>"

echo "</div>"

echo "<br><strong>🔬 Detailed Analysis:</strong><br>"
echo "<div class='detailed-analysis'>"

echo "<div class='detail-section'>"
echo "<h6>Character Analysis:</h6>"
echo "<ul>"
echo "<li><strong>Character Set:</strong> $CHARSET</li>"
echo "<li><strong>Length:</strong> $HASH_LENGTH characters</li>"
if [[ -n "$PATTERNS" ]]; then
    echo "<li><strong>Detected Patterns:</strong> $PATTERNS</li>"
fi
echo "</ul>"
echo "</div>"

echo "<div class='detail-section'>"
echo "<h6>Security Recommendations:</h6>"
echo "<ul>"
case $security_level in
    "Very Weak"|"Weak"|"Obsolete")
        echo "<li>⚠️ This hash type is considered weak or obsolete</li>"
        echo "<li>🔄 Migrate to SHA-256 or stronger algorithms</li>"
        echo "<li>🧂 Always use proper salting</li>"
        ;;
    "Compromised")
        echo "<li>🚨 This algorithm has known vulnerabilities</li>"
        echo "<li>🔄 Immediate migration recommended</li>"
        echo "<li>🧂 Use bcrypt, Argon2, or scrypt for passwords</li>"
        ;;
    "Moderate"|"Good")
        echo "<li>✅ Acceptable for non-sensitive data</li>"
        echo "<li>🧂 Ensure proper salting is used</li>"
        echo "<li>🔄 Consider upgrading for sensitive applications</li>"
        ;;
    "Strong"|"Very Strong")
        echo "<li>✅ Good security level for most applications</li>"
        echo "<li>🧂 Verify proper salting implementation</li>"
        echo "<li>⚡ Monitor computational requirements</li>"
        ;;
    "Military Grade")
        echo "<li>🎖️ Excellent choice for high-security applications</li>"
        echo "<li>✅ Resistant to modern attack methods</li>"
        echo "<li>⚡ Ensure proper parameter configuration</li>"
        ;;
esac
echo "</ul>"
echo "</div>"

echo "<div class='detail-section'>"
echo "<h6>Common Attack Methods:</h6>"
echo "<ul>"
case $crack_difficulty in
    "Instant"|"Easy")
        echo "<li>📚 Rainbow Tables</li>"
        echo "<li>🔤 Dictionary Attacks</li>"
        echo "<li>🔥 Brute Force (GPU accelerated)</li>"
        ;;
    "Medium")
        echo "<li>🔤 Advanced Dictionary Attacks</li>"
        echo "<li>🎭 Mask Attacks</li>"
        echo "<li>📊 Statistical Analysis</li>"
        ;;
    "Hard"|"Very Hard")
        echo "<li>🌩️ Distributed Computing</li>"
        echo "<li>🔬 Specialized Hardware (ASICs)</li>"
        echo "<li>⏰ Time-intensive Brute Force</li>"
        ;;
    "Extremely Hard"|"Nearly Impossible")
        echo "<li>🏛️ Nation-state Level Resources</li>"
        echo "<li>🔬 Quantum Computing (theoretical)</li>"
        echo "<li>⏳ Multi-year Time Investment</li>"
        ;;
esac
echo "</ul>"
echo "</div>"

echo "</div>"

echo "<br><strong>🛠️ Recommended Tools:</strong><br>"
echo "<div class='tools-section'>"
echo "<div class='tool-category'>"
echo "<strong>Online Tools:</strong>"
echo "<ul>"
echo "<li>HashKiller</li>"
echo "<li>CrackStation</li>"
echo "<li>MD5Decrypt</li>"
echo "<li>OnlineHashCrack</li>"
echo "</ul>"
echo "</div>"

echo "<div class='tool-category'>"
echo "<strong>Offline Tools:</strong>"
echo "<ul>"
echo "<li>Hashcat</li>"
echo "<li>John the Ripper</li>"
echo "<li>Hydra</li>"
echo "<li>Rainbow Crack</li>"
echo "</ul>"
echo "</div>"
echo "</div>"

echo "</div>"
echo "</div>"