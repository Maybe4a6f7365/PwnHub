#!/bin/bash

# JWT Token Decoder Tool

JWT_INPUT="${FORM_DATA["jwt-input"]}"

if [[ -z "$JWT_INPUT" ]]; then
    echo "<div class='tool-error'>Please enter a JWT token to decode</div>"
    exit 0
fi

JWT_CLEAN=$(echo "$JWT_INPUT" | tr -d ' \n\r\t')

echo "<div class='tool-result'>"
echo "<h4>JWT Token Decoder Results</h4>"
echo "<div class='jwt-results'>"

echo "<strong>Input JWT:</strong><br>"
echo "<div class='text-box jwt-input'>$JWT_CLEAN</div><br>"

IFS='.' read -ra JWT_PARTS <<< "$JWT_CLEAN"

if [[ ${#JWT_PARTS[@]} -ne 3 ]]; then
    echo "<div class='tool-error'>Invalid JWT format. JWT should have 3 parts separated by dots (header.payload.signature)</div>"
    echo "</div></div>"
    exit 0
fi

decode_base64url() {
    local input="$1"
    local padding=$((4 - ${#input} % 4))
    if [[ $padding -ne 4 ]]; then
        input+=$(printf "%*s" $padding | tr ' ' '=')
    fi
    input=$(echo "$input" | tr '_-' '/+')
    echo "$input" | base64 -d 2>/dev/null
}

# Decode header
echo "<strong>🔍 Header:</strong><br>"
header_decoded=$(decode_base64url "${JWT_PARTS[0]}")
if [[ -n "$header_decoded" ]]; then
    echo "<div class='jwt-section'>"
    echo "<div class='jwt-raw'><strong>Raw (Base64URL):</strong> ${JWT_PARTS[0]}</div>"
    echo "<div class='jwt-decoded'><strong>Decoded JSON:</strong><pre>$header_decoded</pre></div>"
    echo "</div>"
    
    alg=$(echo "$header_decoded" | grep -o '"alg":"[^"]*"' | cut -d'"' -f4)
    typ=$(echo "$header_decoded" | grep -o '"typ":"[^"]*"' | cut -d'"' -f4)
    
    echo "<div class='jwt-analysis'>"
    if [[ -n "$alg" ]]; then
        echo "<strong>Algorithm:</strong> $alg<br>"
        case "$alg" in
            "none")
                echo "⚠️ <span class='security-warning'>Algorithm 'none' - No signature verification!</span><br>"
                ;;
            "HS256"|"HS384"|"HS512")
                echo "ℹ️ <span class='security-info'>HMAC algorithm - Symmetric key required</span><br>"
                ;;
            "RS256"|"RS384"|"RS512")
                echo "ℹ️ <span class='security-info'>RSA algorithm - Asymmetric key pair</span><br>"
                ;;
            "ES256"|"ES384"|"ES512")
                echo "ℹ️ <span class='security-info'>ECDSA algorithm - Elliptic curve cryptography</span><br>"
                ;;
        esac
    fi
    if [[ -n "$typ" ]]; then
        echo "<strong>Type:</strong> $typ<br>"
    fi
    echo "</div>"
else
    echo "<div class='tool-error'>Failed to decode header</div>"
fi

echo "<br><strong>📋 Payload:</strong><br>"
payload_decoded=$(decode_base64url "${JWT_PARTS[1]}")
if [[ -n "$payload_decoded" ]]; then
    echo "<div class='jwt-section'>"
    echo "<div class='jwt-raw'><strong>Raw (Base64URL):</strong> ${JWT_PARTS[1]}</div>"
    echo "<div class='jwt-decoded'><strong>Decoded JSON:</strong><pre>$payload_decoded</pre></div>"
    echo "</div>"
    
    echo "<div class='jwt-analysis'>"
    iss=$(echo "$payload_decoded" | grep -o '"iss":"[^"]*"' | cut -d'"' -f4)
    sub=$(echo "$payload_decoded" | grep -o '"sub":"[^"]*"' | cut -d'"' -f4)
    aud=$(echo "$payload_decoded" | grep -o '"aud":"[^"]*"' | cut -d'"' -f4)
    exp=$(echo "$payload_decoded" | grep -o '"exp":[0-9]*' | cut -d':' -f2)
    iat=$(echo "$payload_decoded" | grep -o '"iat":[0-9]*' | cut -d':' -f2)
    nbf=$(echo "$payload_decoded" | grep -o '"nbf":[0-9]*' | cut -d':' -f2)
    
    if [[ -n "$iss" ]]; then echo "<strong>Issuer (iss):</strong> $iss<br>"; fi
    if [[ -n "$sub" ]]; then echo "<strong>Subject (sub):</strong> $sub<br>"; fi
    if [[ -n "$aud" ]]; then echo "<strong>Audience (aud):</strong> $aud<br>"; fi
    
    if [[ -n "$exp" ]]; then
        exp_date=$(date -d "@$exp" 2>/dev/null)
        if [[ $? -eq 0 ]]; then
            current_time=$(date +%s)
            if [[ $exp -lt $current_time ]]; then
                echo "<strong>Expires (exp):</strong> $exp_date ⚠️ <span class='security-warning'>EXPIRED</span><br>"
            else
                echo "<strong>Expires (exp):</strong> $exp_date ✅ <span class='security-good'>Valid</span><br>"
            fi
        else
            echo "<strong>Expires (exp):</strong> $exp<br>"
        fi
    fi
    
    if [[ -n "$iat" ]]; then
        iat_date=$(date -d "@$iat" 2>/dev/null)
        if [[ $? -eq 0 ]]; then
            echo "<strong>Issued At (iat):</strong> $iat_date<br>"
        else
            echo "<strong>Issued At (iat):</strong> $iat<br>"
        fi
    fi
    
    if [[ -n "$nbf" ]]; then
        nbf_date=$(date -d "@$nbf" 2>/dev/null)
        if [[ $? -eq 0 ]]; then
            current_time=$(date +%s)
            if [[ $nbf -gt $current_time ]]; then
                echo "<strong>Not Before (nbf):</strong> $nbf_date ⚠️ <span class='security-warning'>Not yet valid</span><br>"
            else
                echo "<strong>Not Before (nbf):</strong> $nbf_date ✅ <span class='security-good'>Valid</span><br>"
            fi
        else
            echo "<strong>Not Before (nbf):</strong> $nbf<br>"
        fi
    fi
    echo "</div>"
else
    echo "<div class='tool-error'>Failed to decode payload</div>"
fi

echo "<br><strong>🔐 Signature:</strong><br>"
echo "<div class='jwt-section'>"
echo "<div class='jwt-raw'><strong>Raw (Base64URL):</strong> ${JWT_PARTS[2]}</div>"
echo "<div class='jwt-analysis'>"
echo "⚠️ <span class='security-warning'>Signature verification requires the secret key or public key</span><br>"
echo "🔍 Use tools like jwt.io or specialized libraries to verify signature integrity"
echo "</div>"
echo "</div>"

echo "<br><strong>🛡️ Security Analysis:</strong><br>"
echo "<div class='security-analysis'>"

if [[ "$alg" == "none" ]]; then
    echo "🚨 <strong>Critical:</strong> Algorithm 'none' means no signature verification!<br>"
    echo "⚠️ This token can be modified by anyone<br>"
elif [[ "$alg" =~ ^HS ]]; then
    echo "ℹ️ HMAC algorithm requires shared secret key<br>"
    echo "⚠️ Vulnerable to brute force attacks if weak secret<br>"
elif [[ "$alg" =~ ^RS ]]; then
    echo "ℹ️ RSA algorithm uses public/private key pair<br>"
    echo "✅ More secure than HMAC if properly implemented<br>"
fi

if [[ -n "$exp" ]]; then
    current_time=$(date +%s)
    if [[ $exp -lt $current_time ]]; then
        echo "🚨 Token is expired and should not be accepted<br>"
    fi
fi

echo "📝 Always verify the signature and claims before trusting JWT content<br>"
echo "</div>"

echo "</div>"
echo "</div>"

EOF 