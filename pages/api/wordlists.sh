#!/bin/bash

source includes/icons.sh

cat << EOF
<div class="wordlists-container">
    <!-- Wordlists Content -->
    <div class="tools-content">
        <div class="tools-grid">
            <!-- Directory Brute-force Wordlist -->
            <div class="tool-card" data-tool="directories">
                <div class="tool-header">
                    <div class="tool-icon">📁</div>
                    <div class="tool-info">
                        <h3 class="tool-title">Directory Wordlist</h3>
                        <p class="tool-desc">OWASP DirBuster medium wordlist for directory brute-forcing</p>
                    </div>
                </div>
                <div class="tool-body">
                    <div class="wordlist-info">
                        <div class="info-item">
                            <strong>Source:</strong> OWASP DirBuster
                        </div>
                        <div class="info-item">
                            <strong>Size:</strong> ~220,000 entries
                        </div>
                        <div class="info-item">
                            <strong>Use Case:</strong> Web directory enumeration
                        </div>
                    </div>
                    <div class="tool-actions">
                        <a href="https://raw.githubusercontent.com/foospidy/payloads/refs/heads/master/owasp/dirbuster/directory-list-2.3-medium.txt" 
                           class="tool-btn primary" download="directory-list-medium.txt" target="_blank">
                            📥 Download Wordlist
                        </a>
                        <button class="tool-btn secondary" onclick="copyToClipboard('https://raw.githubusercontent.com/foospidy/payloads/refs/heads/master/owasp/dirbuster/directory-list-2.3-medium.txt')">
                            📋 Copy URL
                        </button>
                    </div>
                </div>
            </div>

            <!-- Subdomain Wordlist -->
            <div class="tool-card" data-tool="subdomains">
                <div class="tool-header">
                    <div class="tool-icon">🌐</div>
                    <div class="tool-info">
                        <h3 class="tool-title">Subdomain Wordlist</h3>
                        <p class="tool-desc">Comprehensive subdomain enumeration wordlist by n0kovo</p>
                    </div>
                </div>
                <div class="tool-body">
                    <div class="wordlist-info">
                        <div class="info-item">
                            <strong>Source:</strong> n0kovo_subdomains
                        </div>
                        <div class="info-item">
                            <strong>Size:</strong> ~3M+ entries
                        </div>
                        <div class="info-item">
                            <strong>Use Case:</strong> Subdomain brute-forcing
                        </div>
                    </div>
                    <div class="tool-actions">
                        <a href="https://raw.githubusercontent.com/n0kovo/n0kovo_subdomains/refs/heads/main/n0kovo_subdomains_huge.txt" 
                           class="tool-btn primary" download="subdomains-huge.txt" target="_blank">
                            📥 Download Wordlist
                        </a>
                        <button class="tool-btn secondary" onclick="copyToClipboard('https://raw.githubusercontent.com/n0kovo/n0kovo_subdomains/refs/heads/main/n0kovo_subdomains_huge.txt')">
                            📋 Copy URL
                        </button>
                    </div>
                </div>
            </div>

            <!-- SQL Injection Wordlist -->
            <div class="tool-card" data-tool="sql">
                <div class="tool-header">
                    <div class="tool-icon">💉</div>
                    <div class="tool-info">
                        <h3 class="tool-title">SQL Injection Payloads</h3>
                        <p class="tool-desc">Curated SQL injection payloads for testing</p>
                    </div>
                </div>
                <div class="tool-body">
                    <div class="wordlist-info">
                        <div class="info-item">
                            <strong>Source:</strong> PwnHub Collection
                        </div>
                        <div class="info-item">
                            <strong>Size:</strong> Curated payload set
                        </div>
                        <div class="info-item">
                            <strong>Use Case:</strong> SQL injection testing
                        </div>
                    </div>
                    <div class="tool-actions">
                        <a href="/api/wordlists/sql" class="tool-btn primary" download="sql-payloads.txt" target="_blank">
                            📥 Download Wordlist
                        </a>
                        <button class="tool-btn secondary" onclick="copyToClipboard('/api/wordlists/sql')">
                            📋 Copy URL
                        </button>
                    </div>
                </div>
            </div>

            <!-- Command Injection Wordlist -->
            <div class="tool-card" data-tool="command">
                <div class="tool-header">
                    <div class="tool-icon">⚡</div>
                    <div class="tool-info">
                        <h3 class="tool-title">Command Injection</h3>
                        <p class="tool-desc">Unix/Linux command injection payloads</p>
                    </div>
                </div>
                <div class="tool-body">
                    <div class="wordlist-info">
                        <div class="info-item">
                            <strong>Source:</strong> Ismail Tasdelen
                        </div>
                        <div class="info-item">
                            <strong>Size:</strong> Unix/Linux focused
                        </div>
                        <div class="info-item">
                            <strong>Use Case:</strong> Command injection testing
                        </div>
                    </div>
                    <div class="tool-actions">
                        <a href="https://raw.githubusercontent.com/foospidy/payloads/refs/heads/master/other/commandinjection/ismailtasdelen-unix.txt" 
                           class="tool-btn primary" download="command-injection-unix.txt" target="_blank">
                            📥 Download Wordlist
                        </a>
                        <button class="tool-btn secondary" onclick="copyToClipboard('https://raw.githubusercontent.com/foospidy/payloads/refs/heads/master/other/commandinjection/ismailtasdelen-unix.txt')">
                            📋 Copy URL
                        </button>
                    </div>
                </div>
            </div>

            <!-- Path Traversal Wordlist -->
            <div class="tool-card" data-tool="traversal">
                <div class="tool-header">
                    <div class="tool-icon">📂</div>
                    <div class="tool-info">
                        <h3 class="tool-title">Path Traversal</h3>
                        <p class="tool-desc">Directory traversal payloads from DotDotPwn</p>
                    </div>
                </div>
                <div class="tool-body">
                    <div class="wordlist-info">
                        <div class="info-item">
                            <strong>Source:</strong> DotDotPwn Project
                        </div>
                        <div class="info-item">
                            <strong>Size:</strong> Comprehensive traversal set
                        </div>
                        <div class="info-item">
                            <strong>Use Case:</strong> Path traversal testing
                        </div>
                    </div>
                    <div class="tool-actions">
                        <a href="https://raw.githubusercontent.com/foospidy/payloads/refs/heads/master/other/traversal/dotdotpwn.txt" 
                           class="tool-btn primary" download="path-traversal.txt" target="_blank">
                            📥 Download Wordlist
                        </a>
                        <button class="tool-btn secondary" onclick="copyToClipboard('https://raw.githubusercontent.com/foospidy/payloads/refs/heads/master/other/traversal/dotdotpwn.txt')">
                            📋 Copy URL
                        </button>
                    </div>
                </div>
            </div>

            <!-- XSS Payloads -->
            <div class="tool-card" data-tool="xss">
                <div class="tool-header">
                    <div class="tool-icon">🔥</div>
                    <div class="tool-info">
                        <h3 class="tool-title">XSS Payloads</h3>
                        <p class="tool-desc">Cross-Site Scripting payload collection</p>
                    </div>
                </div>
                <div class="tool-body">
                    <div class="wordlist-info">
                        <div class="info-item">
                            <strong>Source:</strong> Security Research
                        </div>
                        <div class="info-item">
                            <strong>Size:</strong> Various XSS vectors
                        </div>
                        <div class="info-item">
                            <strong>Use Case:</strong> XSS vulnerability testing
                        </div>
                    </div>
                    <div class="tool-actions">
                        <a href="https://raw.githubusercontent.com/foospidy/payloads/refs/heads/master/other/xss/payloads.txt" 
                           class="tool-btn primary" download="xss-payloads.txt" target="_blank">
                            📥 Download Wordlist
                        </a>
                        <button class="tool-btn secondary" onclick="copyToClipboard('https://raw.githubusercontent.com/foospidy/payloads/refs/heads/master/other/xss/payloads.txt')">
                            📋 Copy URL
                        </button>
                    </div>
                </div>
            </div>

            <!-- Upload Wordlist Form -->
            <div class="tool-card upload-card" data-tool="upload">
                <div class="tool-header">
                    <div class="tool-icon">📤</div>
                    <div class="tool-info">
                        <h3 class="tool-title">Upload Wordlist</h3>
                        <p class="tool-desc">Share your custom wordlists with the community (max 50MB)</p>
                    </div>
                </div>
                <div class="tool-body">
                    <form id="wordlist-upload-form" enctype="multipart/form-data" action="#" onsubmit="return false;">
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Select Wordlist File</label>
                                <input type="file" id="wordlist-file" name="wordlist-file" class="form-input file-input" 
                                       accept=".txt,.list,.wordlist,.dict" required>
                                <small class="form-hint">Accepted formats: .txt, .list, .wordlist, .dict</small>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Category</label>
                                <select id="wordlist-category" name="wordlist-category" class="form-input">
                                    <option value="Directory Enumeration">Directory Enumeration</option>
                                    <option value="Subdomain Discovery">Subdomain Discovery</option>
                                    <option value="Password Lists">Password Lists</option>
                                    <option value="Usernames">Usernames</option>
                                    <option value="SQL Injection">SQL Injection</option>
                                    <option value="XSS Payloads">XSS Payloads</option>
                                    <option value="Command Injection">Command Injection</option>
                                    <option value="Fuzzing">Fuzzing</option>
                                    <option value="Custom">Custom</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Description (Optional)</label>
                            <textarea id="wordlist-description" name="wordlist-description" class="form-input" 
                                     placeholder="Describe your wordlist, its purpose, or source..." rows="3" maxlength="200"></textarea>
                            <small class="form-hint">Max 200 characters</small>
                        </div>
                        <div class="tool-actions">
                            <button type="button" class="tool-btn primary" onclick="uploadWordlist(); return false;">
                                📤 Upload Wordlist
                            </button>
                            <button type="reset" class="tool-btn secondary">
                                🔄 Reset Form
                            </button>
                        </div>
                    </form>
                    <div id="upload-result" class="tool-result"></div>
                </div>
            </div>

            <!-- Uploaded Wordlists will be loaded here by JavaScript -->
            <div id="uploaded-wordlists-container">
                <!-- Uploaded wordlists will be loaded here -->
            </div>
        </div>
    </div>
</div>

<script>
// Wordlist upload functionality
document.addEventListener('DOMContentLoaded', function() {
    // Handle wordlist upload form
    const uploadForm = document.getElementById('wordlist-upload-form');
    if (uploadForm) {
        uploadForm.addEventListener('submit', function(e) {
            e.preventDefault();
            e.stopPropagation();
            uploadWordlist();
            return false;
        });
    }
    
    // Load uploaded wordlists on page load
    setTimeout(function() {
        loadUploadedWordlists();
    }, 500);
});

function uploadWordlist() {
    const form = document.getElementById('wordlist-upload-form');
    const fileInput = document.getElementById('wordlist-file');
    const resultDiv = document.getElementById('upload-result');
    
    if (!fileInput.files || fileInput.files.length === 0) {
        resultDiv.innerHTML = '<div class="tool-error">Please select a file to upload</div>';
        return false;
    }
    
    const file = fileInput.files[0];
    const maxSize = 50 * 1024 * 1024; // 50MB
    
    if (file.size > maxSize) {
        resultDiv.innerHTML = '<div class="tool-error">File too large. Maximum size: 50MB</div>';
        return false;
    }
    
    // Show loading state
    resultDiv.innerHTML = '<div class="upload-loading">📤 Uploading wordlist... <div class="loading-spinner"></div></div>';
    
    // Create FormData
    const formData = new FormData(form);
    formData.append('wordlist-filename', file.name);
    
    // Upload using fetch
    fetch('/api/wordlists/upload', {
        method: 'POST',
        body: formData
    })
    .then(response => response.text())
    .then(html => {
        resultDiv.innerHTML = html;
        // Reset form on success and refresh uploaded wordlists immediately
        if (html.includes('upload-success')) {
            form.reset();
            // Refresh the uploaded wordlists immediately
            setTimeout(() => {
                loadUploadedWordlists();
            }, 100);
            // Show success notification
            showNotification('Wordlist uploaded successfully!', 'success');
        }
    })
    .catch(error => {
        console.error('Upload error:', error);
        resultDiv.innerHTML = '<div class="tool-error">Upload failed. Please try again.</div>';
    });
    
    return false;
}

function loadUploadedWordlists() {
    const container = document.getElementById('uploaded-wordlists-container');
    if (!container) {
        return;
    }
    
    container.innerHTML = '<div class="loading-wordlists">📚 Loading uploaded wordlists...</div>';
    
    fetch('/api/wordlists/list')
    .then(response => response.text())
    .then(html => {
        container.innerHTML = html;
    })
    .catch(error => {
        console.error('Failed to load uploaded wordlists:', error);
        container.innerHTML = '<div class="tool-error">Failed to load uploaded wordlists</div>';
    });
}

function refreshUploadedWordlists() {
    loadUploadedWordlists();
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
    // Additional form handling to prevent any redirects
    const uploadForm = document.getElementById('wordlist-upload-form');
    if (uploadForm) {
        // Prevent any form submission that might cause navigation
        uploadForm.onsubmit = function(e) {
            e.preventDefault();
            e.stopPropagation();
            uploadWordlist();
            return false;
        };
        
        // Also handle the button click directly
        const submitButton = uploadForm.querySelector('button[type="submit"]');
        if (submitButton) {
            submitButton.onclick = function(e) {
                e.preventDefault();
                e.stopPropagation();
                uploadWordlist();
                return false;
            };
        }
    }
};
</script> 