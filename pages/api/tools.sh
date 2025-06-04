#!/bin/bash

source includes/icons.sh

cat << EOF
<div class="tools-container">
    <!-- Navigation Tabs -->
    <div class="tools-navigation">
        <nav class="tools-nav">
            <button class="nav-tab active" data-category="encoding" onclick="showCategory('encoding', this)">
                ${FILE_TEXT_ICON}
                <span>Text & Encoding</span>
            </button>
            <button class="nav-tab" data-category="crypto" onclick="showCategory('crypto', this)">
                ${SHIELD_ICON}
                <span>Cryptography</span>
            </button>
            <button class="nav-tab" data-category="web" onclick="showCategory('web', this)">
                ${GLOBE_ICON}
                <span>Web Security</span>
            </button>
            <button class="nav-tab" data-category="steganography" onclick="showCategory('steganography', this)">
                ${EYE_ICON}
                <span>Steganography</span>
            </button>
        </nav>
    </div>

    <!-- Tools Content -->
    <div class="tools-content">
        <!-- Text & Encoding -->
        <div class="category-section active" id="category-encoding">
            <div class="tools-grid">
                <!-- JSON Formatter -->
                <div class="tool-card" data-tool="json">
                    <div class="tool-header">
                        <div class="tool-icon">${CODE_ICON}</div>
                        <div class="tool-info">
                            <h3 class="tool-title">JSON Formatter</h3>
                            <p class="tool-desc">Format, validate and analyze JSON data structures</p>
                        </div>
                    </div>
                    <div class="tool-body">
                        <div class="form-group">
                            <textarea id="json-input" name="json-input" class="tool-textarea" placeholder="Paste your JSON here..." rows="6"></textarea>
                        </div>
                        <div class="tool-actions">
                            <button class="tool-btn primary" hx-post="/api/tools/json-formatter" hx-include="#json-input" hx-target="#json-output" hx-vals='{"operation": "format"}'>
                                Format JSON
                            </button>
                            <button class="tool-btn secondary" hx-post="/api/tools/json-formatter" hx-include="#json-input" hx-target="#json-output" hx-vals='{"operation": "minify"}'>
                                Minify
                            </button>
                            <button class="tool-btn secondary" hx-post="/api/tools/json-formatter" hx-include="#json-input" hx-target="#json-output" hx-vals='{"operation": "validate"}'>
                                Validate
                            </button>
                        </div>
                        <div id="json-output" class="tool-result"></div>
                    </div>
                </div>

                <!-- Hash Identifier -->
                <div class="tool-card" data-tool="hash">
                    <div class="tool-header">
                        <div class="tool-icon">${HASH_ICON}</div>
                        <div class="tool-info">
                            <h3 class="tool-title">Hash Identifier</h3>
                            <p class="tool-desc">Identify hash types and get security analysis from 100+ formats</p>
                        </div>
                    </div>
                    <div class="tool-body">
                        <div class="form-group">
                            <input type="text" id="hash-input" name="hash-input" class="form-input" placeholder="5d41402abc4b2a76b9719d911017c592">
                        </div>
                        <div class="tool-actions">
                            <button class="tool-btn primary" hx-post="/api/tools/hash-identifier" hx-include="#hash-input" hx-target="#hash-output">
                                Identify Hash
                            </button>
                        </div>
                        <div id="hash-output" class="tool-result"></div>
                    </div>
                </div>

                <!-- Base Converter -->
                <div class="tool-card" data-tool="base">
                    <div class="tool-header">
                        <div class="tool-icon">${CALCULATOR_ICON}</div>
                        <div class="tool-info">
                            <h3 class="tool-title">Base Converter</h3>
                            <p class="tool-desc">Convert numbers between different bases (binary, decimal, hex, octal)</p>
                        </div>
                    </div>
                    <div class="tool-body">
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Number</label>
                                <input type="text" id="base-input" name="base-input" class="form-input" placeholder="Enter number">
                            </div>
                            <div class="form-group">
                                <label class="form-label">From Base</label>
                                <select id="base-from" name="base-from" class="form-select">
                                    <option value="10">Decimal (10)</option>
                                    <option value="16">Hexadecimal (16)</option>
                                    <option value="8">Octal (8)</option>
                                    <option value="2">Binary (2)</option>
                                </select>
                            </div>
                        </div>
                        <div class="tool-actions">
                            <button class="tool-btn primary" hx-post="/api/tools/base-converter" hx-include="#base-input,#base-from" hx-target="#base-output">
                                Convert All Bases
                            </button>
                        </div>
                        <div id="base-output" class="tool-result"></div>
                    </div>
                </div>

                <!-- URL Encoder/Decoder -->
                <div class="tool-card" data-tool="url">
                    <div class="tool-header">
                        <div class="tool-icon">${GLOBE_ICON}</div>
                        <div class="tool-info">
                            <h3 class="tool-title">URL Encoder/Decoder</h3>
                            <p class="tool-desc">Encode and decode URL strings and parameters</p>
                        </div>
                    </div>
                    <div class="tool-body">
                        <div class="form-group">
                            <textarea id="url-input" name="url-input" class="tool-textarea" placeholder="Enter text or URL to encode/decode..." rows="4"></textarea>
                        </div>
                        <div class="tool-actions">
                            <button class="tool-btn primary" hx-post="/api/tools/url-encoder" hx-include="#url-input" hx-target="#url-output" hx-vals='{"operation": "encode"}'>
                                URL Encode
                            </button>
                            <button class="tool-btn secondary" hx-post="/api/tools/url-encoder" hx-include="#url-input" hx-target="#url-output" hx-vals='{"operation": "decode"}'>
                                URL Decode
                            </button>
                        </div>
                        <div id="url-output" class="tool-result"></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Cryptography -->
        <div class="category-section" id="category-crypto">
            <div class="tools-grid">
                <!-- Caesar Cipher -->
                <div class="tool-card" data-tool="caesar">
                    <div class="tool-header">
                        <div class="tool-icon">${CODE_ICON}</div>
                        <div class="tool-info">
                            <h3 class="tool-title">Caesar Cipher</h3>
                            <p class="tool-desc">Encode/decode Caesar cipher with all rotations</p>
                        </div>
                    </div>
                    <div class="tool-body">
                        <div class="form-group">
                            <textarea id="caesar-input" name="caesar-input" class="tool-textarea" placeholder="Enter text to encode/decode..." rows="4"></textarea>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Rotation (optional)</label>
                                <input type="number" id="caesar-rotation" name="caesar-rotation" class="form-input" placeholder="1-25 or leave empty" min="1" max="25">
                            </div>
                        </div>
                        <div class="tool-actions">
                            <button class="tool-btn primary" hx-post="/api/tools/caesar-decoder" hx-include="#caesar-input,#caesar-rotation" hx-target="#caesar-output">
                                Decode (All Rotations)
                            </button>
                        </div>
                        <div id="caesar-output" class="tool-result"></div>
                    </div>
                </div>

                <!-- GCD/LCM Calculator -->
                <div class="tool-card" data-tool="gcd">
                    <div class="tool-header">
                        <div class="tool-icon">${CALCULATOR_ICON}</div>
                        <div class="tool-info">
                            <h3 class="tool-title">GCD/LCM Calculator</h3>
                            <p class="tool-desc">Calculate Greatest Common Divisor and Least Common Multiple</p>
                        </div>
                    </div>
                    <div class="tool-body">
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">First Number</label>
                                <input type="number" id="gcd-num1" name="gcd-num1" class="form-input" placeholder="24">
                            </div>
                        <div class="form-group">
                                <label class="form-label">Second Number</label>
                                <input type="number" id="gcd-num2" name="gcd-num2" class="form-input" placeholder="36">
                            </div>
                        </div>
                        <div class="tool-actions">
                            <button class="tool-btn primary" hx-post="/api/tools/gcd-lcm" hx-include="#gcd-num1,#gcd-num2" hx-target="#gcd-output">
                                Calculate GCD/LCM
                            </button>
                        </div>
                        <div id="gcd-output" class="tool-result"></div>
            </div>
        </div>

                <!-- Prime Number Checker -->
                <div class="tool-card" data-tool="prime">
                    <div class="tool-header">
                        <div class="tool-icon">${CALCULATOR_ICON}</div>
                        <div class="tool-info">
                            <h3 class="tool-title">Prime Number Tools</h3>
                            <p class="tool-desc">Check if a number is prime and find prime factors</p>
                        </div>
                    </div>
                    <div class="tool-body">
                        <div class="form-group">
                            <label class="form-label">Number</label>
                            <input type="number" id="prime-input" name="prime-input" class="form-input" placeholder="Enter a number">
                        </div>
                        <div class="tool-actions">
                            <button class="tool-btn primary" hx-post="/api/tools/prime-checker" hx-include="#prime-input" hx-target="#prime-output">
                                Check Prime & Factor
                            </button>
                        </div>
                        <div id="prime-output" class="tool-result"></div>
                    </div>
                </div>
                    </div>
                </div>

        <!-- Web Security -->
        <div class="category-section" id="category-web">
            <div class="tools-grid">
                <!-- Timestamp Converter -->
                <div class="tool-card" data-tool="timestamp">
                    <div class="tool-header">
                        <div class="tool-icon">${CLOCK_ICON}</div>
                        <div class="tool-info">
                            <h3 class="tool-title">Timestamp Converter</h3>
                            <p class="tool-desc">Convert between different timestamp formats</p>
                        </div>
                    </div>
                    <div class="tool-body">
                        <div class="form-group">
                            <input type="text" id="timestamp-input" name="timestamp-input" class="form-input" placeholder="1634567890 or 2021-10-18T10:31:30Z">
                        </div>
                        <div class="tool-actions">
                            <button class="tool-btn primary" hx-post="/api/tools/timestamp-converter" hx-include="#timestamp-input" hx-target="#timestamp-output">
                                Convert Timestamp
                            </button>
                            <button class="tool-btn secondary" hx-post="/api/tools/timestamp-converter" hx-target="#timestamp-output" hx-vals='{"current": "true"}'>
                                Current Time
                            </button>
                        </div>
                        <div id="timestamp-output" class="tool-result"></div>
                    </div>
                </div>

                <!-- JWT Decoder -->
                <div class="tool-card" data-tool="jwt">
                    <div class="tool-header">
                        <div class="tool-icon">${SHIELD_ICON}</div>
                        <div class="tool-info">
                            <h3 class="tool-title">JWT Token Decoder</h3>
                            <p class="tool-desc">Decode and analyze JSON Web Tokens</p>
                        </div>
                    </div>
                    <div class="tool-body">
                        <div class="form-group">
                            <textarea id="jwt-input" name="jwt-input" class="tool-textarea" placeholder="Paste JWT token here..." rows="4"></textarea>
                        </div>
                        <div class="tool-actions">
                            <button class="tool-btn primary" hx-post="/api/tools/jwt-decoder" hx-include="#jwt-input" hx-target="#jwt-output">
                                Decode JWT
                            </button>
                        </div>
                        <div id="jwt-output" class="tool-result"></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Steganography -->
        <div class="category-section" id="category-steganography">
            <div class="tools-grid">
                <!-- Text Hidden Message Finder -->
                <div class="tool-card large-card" data-tool="hidden">
                    <div class="tool-header">
                        <div class="tool-icon">${EYE_ICON}</div>
                        <div class="tool-info">
                            <h3 class="tool-title">Hidden Message Analyzer</h3>
                            <p class="tool-desc">Comprehensive analysis to find hidden messages in text using multiple steganography techniques</p>
                        </div>
                    </div>
                    <div class="tool-body">
                        <div class="form-group">
                            <textarea id="hidden-input" name="hidden-input" class="tool-textarea" placeholder="Enter text to analyze for hidden messages..." rows="8"></textarea>
                        </div>
                        <div class="tool-actions">
                            <button class="tool-btn primary" hx-post="/api/tools/hidden-message" hx-include="#hidden-input" hx-target="#hidden-output">
                                Find Hidden Messages
                            </button>
                        </div>
                        <div id="hidden-output" class="tool-result"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function showCategory(category, clickedTab) {
    // Hide all sections
    var sections = document.querySelectorAll('.category-section');
    for (var i = 0; i < sections.length; i++) {
        sections[i].style.display = 'none';
        sections[i].classList.remove('active');
    }
    
    // Remove active from all tabs
    var tabs = document.querySelectorAll('.nav-tab');
    for (var i = 0; i < tabs.length; i++) {
        tabs[i].classList.remove('active');
    }
    
    // Show target section
    var targetSection = document.getElementById('category-' + category);
    if (targetSection) {
        targetSection.style.display = 'block';
        targetSection.classList.add('active');
    } else {
        console.error('Section not found:', 'category-' + category);
        return;
    }
    
    // Activate clicked tab
    clickedTab.classList.add('active');
}

// Copy to clipboard function
function copyToClipboard(text) {
    if (navigator.clipboard && window.isSecureContext) {
        navigator.clipboard.writeText(text).then(function() {
            showNotification('URL copied to clipboard!', 'success');
        }).catch(function(err) {
            console.error('Failed to copy: ', err);
            fallbackCopyTextToClipboard(text);
        });
    } else {
        fallbackCopyTextToClipboard(text);
    }
}

// Fallback copy function
function fallbackCopyTextToClipboard(text) {
    var textArea = document.createElement("textarea");
    textArea.value = text;
    textArea.style.top = "0";
    textArea.style.left = "0";
    textArea.style.position = "fixed";
    document.body.appendChild(textArea);
    textArea.focus();
    textArea.select();
    
    try {
        var successful = document.execCommand('copy');
        if (successful) {
            showNotification('URL copied to clipboard!', 'success');
        } else {
            showNotification('Failed to copy URL', 'error');
        }
    } catch (err) {
        console.error('Fallback: Oops, unable to copy', err);
        showNotification('Copy failed - please copy manually', 'error');
    }
    
    document.body.removeChild(textArea);
}

// Show notification
function showNotification(message, type) {
    var notification = document.createElement('div');
    notification.className = 'notification notification-' + type;
    notification.textContent = message;
    notification.style.cssText = 'position:fixed;top:20px;right:20px;z-index:9999;padding:12px 20px;border-radius:8px;color:white;font-weight:600;opacity:0;transition:opacity 0.3s ease;';
    
    if (type === 'success') {
        notification.style.background = 'var(--success)';
    } else {
        notification.style.background = 'var(--danger)';
    }
    
    document.body.appendChild(notification);
    
    // Fade in
    setTimeout(function() {
        notification.style.opacity = '1';
    }, 100);
    
    // Fade out and remove
    setTimeout(function() {
        notification.style.opacity = '0';
        setTimeout(function() {
            if (notification.parentNode) {
                document.body.removeChild(notification);
            }
        }, 300);
    }, 3000);
}

// Initialize on page load
window.onload = function() {
    // Make sure encoding tab is active initially
    showCategory('encoding', document.querySelector('[data-category="encoding"]'));
};
</script>
EOF
