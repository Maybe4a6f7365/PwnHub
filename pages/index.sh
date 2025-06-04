#!/bin/bash

source config.sh

source includes/icons.sh

cat << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PwnHub - CTF Collaboration Platform</title>
    <link rel="stylesheet" href="/static/style.css">
    <script src="https://unpkg.com/htmx.org@1.9.10"></script>
    <script src="/static/script.js"></script>
</head>
<body>
EOF

if [ "${SESSION[authenticated]}" = "true" ]; then
    cat << EOF
    <div class="app-container">
        <!-- Header -->
        <header class="header">
            <div class="header-left">
                <div class="logo">
                    <span class="brand-pwn">Pwn</span><span class="brand-hub">Hub</span>
                </div>
            </div>
            
            <div class="header-right">
                <button class="settings-icon" onclick="openSettingsModal()">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="3"/>
                        <path d="M12 1v6"/>
                        <path d="M12 17v6"/>
                        <path d="M4.22 4.22l4.24 4.24"/>
                        <path d="M15.54 15.54l4.24 4.24"/>
                        <path d="M1 12h6"/>
                        <path d="M17 12h6"/>
                        <path d="M4.22 19.78l4.24-4.24"/>
                        <path d="M15.54 8.46l4.24-4.24"/>
                    </svg>
                </button>
                
                <button class="add-btn" onclick="openAddChallengeModal()">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="12" y1="5" x2="12" y2="19"/>
                        <line x1="5" y1="12" x2="19" y2="12"/>
                    </svg>
                    <span>Add Challenge</span>
                </button>
            </div>
        </header>

        <div class="main-layout">
            <!-- Sidebar -->
            <aside class="sidebar">
                <nav>
                    <ul class="nav-menu">
                        <li class="nav-item">
                            <a href="#" class="nav-link active" 
                               hx-get="/api/content?tab=challenges" 
                               hx-target="#main-content">
                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                </svg>
                                Challenges
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="#" class="nav-link" 
                               hx-get="/api/content?tab=tools" 
                               hx-target="#main-content">
                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M12 15l3.5-3.5a2.5 2.5 0 1 0-3.5-3.5L8.5 11.5a2.5 2.5 0 1 0 3.5 3.5z"/>
                                    <path d="M9 12h.01M15 12h.01"/>
                                </svg>
                                Tools
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="#" class="nav-link" 
                               hx-get="/api/content?tab=wordlists" 
                               hx-target="#main-content">
                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14 2z"/>
                                    <polyline points="14,2 14,8 20,8"/>
                                    <line x1="16" y1="13" x2="8" y2="13"/>
                                    <line x1="16" y1="17" x2="8" y2="17"/>
                                    <line x1="10" y1="9" x2="8" y2="9"/>
                                </svg>
                                Wordlists
                            </a>
                        </li>
                    </ul>
                </nav>

                <!-- Team Members -->
                <div class="team-section" 
                     hx-get="/api/team" 
                     hx-trigger="load, every 30s"
                     hx-swap="innerHTML">
                    <!-- Team members will load here -->
                </div>
            </aside>

            <!-- Main Content -->
            <main class="main-content" 
                  id="main-content"
                  hx-get="/api/content?tab=challenges" 
                  hx-trigger="load"
                  hx-swap="innerHTML">
                <!-- Content will load here -->
            </main>
        </div>

        <!-- Right Panel (for challenge details) -->
        <div class="right-panel" id="right-panel">
            <!-- Challenge details will load here -->
        </div>
        
        <!-- Add Challenge Modal -->
        <div class="modal" id="add-challenge-modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>Add New Challenge</h2>
                    <button class="close-btn" onclick="closeAddChallengeModal()">&times;</button>
                </div>
                <form hx-post="/api/add-challenge" hx-target="#challenge-response" hx-swap="innerHTML">
                    <div id="challenge-response"></div>
                    <div class="form-group">
                        <label class="form-label">Challenge Name</label>
                        <input type="text" name="name" class="form-input" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Category</label>
                        <select name="category" class="form-input" required>
                            <option value="">Select Category</option>
                            <option value="Web">Web</option>
                            <option value="Pwn">Pwn</option>
                            <option value="Crypto">Crypto</option>
                            <option value="Reverse">Reverse</option>
                            <option value="Forensics">Forensics</option>
                            <option value="Misc">Misc</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Points</label>
                        <input type="number" name="points" class="form-input" min="1" max="1000" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Difficulty</label>
                        <select name="difficulty" class="form-input" required>
                            <option value="">Select Difficulty</option>
                            <option value="Easy">Easy</option>
                            <option value="Medium">Medium</option>
                            <option value="Hard">Hard</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Description</label>
                        <textarea name="description" class="form-input" rows="3" placeholder="Challenge description..."></textarea>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Tags (comma-separated)</label>
                        <input type="text" name="tags" class="form-input" placeholder="web, sql, authentication">
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-primary">Add Challenge</button>
                        <button type="button" class="btn btn-secondary" onclick="closeAddChallengeModal()">Cancel</button>
                    </div>
                </form>
            </div>
        </div>
        
        <!-- Settings Modal -->
        <div class="modal" id="settings-modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>User Settings</h2>
                    <button class="close-btn" onclick="closeSettingsModal()">&times;</button>
                </div>
                <form hx-post="/api/update-profile" hx-target="#settings-response" hx-swap="innerHTML">
                    <div id="settings-response"></div>
                    
                    <div class="form-group">
                        <label class="form-label">Username</label>
                        <input type="text" name="username" class="form-input" value="${SESSION[username]}" readonly>
                        <small class="form-hint">Username cannot be changed</small>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Display Name</label>
                        <input type="text" name="display_name" class="form-input" value="${SESSION[display_name]}" required>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Specialty</label>
                        <select name="specialty" class="form-input" required>
                            <option value="Web Expert" $([ "${SESSION[specialty]}" = "Web Expert" ] && echo "selected")>Web Expert</option>
                            <option value="Pwn Specialist" $([ "${SESSION[specialty]}" = "Pwn Specialist" ] && echo "selected")>Pwn Specialist</option>
                            <option value="Crypto Master" $([ "${SESSION[specialty]}" = "Crypto Master" ] && echo "selected")>Crypto Master</option>
                            <option value="Forensics Analyst" $([ "${SESSION[specialty]}" = "Forensics Analyst" ] && echo "selected")>Forensics Analyst</option>
                            <option value="Reverse Engineer" $([ "${SESSION[specialty]}" = "Reverse Engineer" ] && echo "selected")>Reverse Engineer</option>
                            <option value="Network Security" $([ "${SESSION[specialty]}" = "Network Security" ] && echo "selected")>Network Security</option>
                            <option value="Malware Analyst" $([ "${SESSION[specialty]}" = "Malware Analyst" ] && echo "selected")>Malware Analyst</option>
                            <option value="OSINT Specialist" $([ "${SESSION[specialty]}" = "OSINT Specialist" ] && echo "selected")>OSINT Specialist</option>
                            <option value="General CTF Player" $([ "${SESSION[specialty]}" = "General CTF Player" ] && echo "selected")>General CTF Player</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Current Password</label>
                        <input type="password" name="current_password" class="form-input" placeholder="Enter current password to make changes">
                        <small class="form-hint">Required to update profile or change password</small>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">New Password (optional)</label>
                        <input type="password" name="new_password" class="form-input" placeholder="Enter new password">
                        <small class="form-hint">Leave blank to keep current password</small>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Confirm New Password</label>
                        <input type="password" name="confirm_password" class="form-input" placeholder="Confirm new password">
                    </div>
                    
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-primary">Update Settings</button>
                        <button type="button" class="btn btn-secondary" onclick="closeSettingsModal()">Cancel</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
EOF
else
    # Show login/register interface for unauthenticated users
    cat << EOF
    <div class="login-container">
        <div class="login-card">
            <div class="login-header">
                <div class="logo">
                    <span class="brand-pwn">Pwn</span><span class="brand-hub">Hub</span>
                </div>
                <h1>CTF Collaboration Platform</h1>
                <p>Join the elite team of cyber security professionals</p>
            </div>
            
            <!-- Auth Toggle Buttons -->
            <div class="auth-toggle">
                <button class="auth-tab active" onclick="showLogin()">Login</button>
                <button class="auth-tab" onclick="showRegister()">Register</button>
            </div>
            
            <!-- Login Form -->
            <div id="login-section" class="auth-section active">
                <form class="auth-form" hx-post="/api/login" hx-target="#auth-response" hx-swap="innerHTML" onsubmit="showLoginMessage()">
                    <div id="auth-response"></div>
                    
                    <div class="form-group">
                        <label class="form-label">Username</label>
                        <input type="text" name="username" class="form-input" required placeholder="Enter your username">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Password</label>
                        <input type="password" name="password" class="form-input" required placeholder="Enter your password">
                    </div>
                    
                    <button type="submit" class="btn btn-primary btn-full">Login</button>
                </form>
            </div>
            
            <!-- Register Form -->
            <div id="register-section" class="auth-section">
                <form class="auth-form" hx-post="/api/register" hx-target="#auth-response" hx-swap="innerHTML" onsubmit="showRegisterMessage()">
                    <div id="auth-response"></div>
                    
                    <div class="form-group">
                        <label class="form-label">Username</label>
                        <input type="text" name="username" class="form-input" required placeholder="Choose a username">
                        <small class="form-hint">Letters, numbers, underscores, and hyphens only</small>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Display Name</label>
                        <input type="text" name="display_name" class="form-input" required placeholder="Your full name">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Specialty</label>
                        <select name="specialty" class="form-input" required>
                            <option value="">Select your specialty</option>
                            <option value="Web Expert">Web Expert</option>
                            <option value="Pwn Specialist">Pwn Specialist</option>
                            <option value="Crypto Master">Crypto Master</option>
                            <option value="Forensics Analyst">Forensics Analyst</option>
                            <option value="Reverse Engineer">Reverse Engineer</option>
                            <option value="Network Security">Network Security</option>
                            <option value="Malware Analyst">Malware Analyst</option>
                            <option value="OSINT Specialist">OSINT Specialist</option>
                            <option value="General CTF Player">General CTF Player</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Password</label>
                        <input type="password" name="password" class="form-input" required placeholder="Create a password">
                        <small class="form-hint">Minimum 8 characters with letters and numbers</small>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Confirm Password</label>
                        <input type="password" name="confirm_password" class="form-input" required placeholder="Confirm your password">
                    </div>
                    
                    <button type="submit" class="btn btn-primary btn-full">Create Account</button>
                </form>
            </div>
        </div>
    </div>
EOF
fi

cat << EOF
    <script>
        function showLoginMessage() {
            showNotification('Give it a second...', 'info');
            setTimeout(() => {
                showNotification('Or maybe two or three seconds, but don\\'t worry.', 'info');
            }, 3000);
        }
        
        function showRegisterMessage() {
            showNotification('Be patient, my friend... hashing takes time.', 'info');
        }
        
        function showLogin() {
            document.getElementById('login-section').classList.add('active');
            document.getElementById('register-section').classList.remove('active');
            document.querySelectorAll('.auth-tab')[0].classList.add('active');
            document.querySelectorAll('.auth-tab')[1].classList.remove('active');
            document.getElementById('auth-response').innerHTML = '';
        }
        
        function showRegister() {
            document.getElementById('register-section').classList.add('active');
            document.getElementById('login-section').classList.remove('active');
            document.querySelectorAll('.auth-tab')[1].classList.add('active');
            document.querySelectorAll('.auth-tab')[0].classList.remove('active');
            document.getElementById('auth-response').innerHTML = '';
        }

        // Handle navigation active states
        document.addEventListener('htmx:afterRequest', function(event) {
            if (event.detail.xhr.status === 200 && event.target.matches('.nav-link')) {
                // Remove active class from all nav links
                document.querySelectorAll('.nav-link').forEach(link => {
                    link.classList.remove('active');
                });
                // Add active class to clicked link
                event.target.classList.add('active');
            }
        });

        // Add Challenge Modal functions
        function openAddChallengeModal() {
            document.getElementById('add-challenge-modal').classList.add('open');
        }

        function closeAddChallengeModal() {
            document.getElementById('add-challenge-modal').classList.remove('open');
        }
        
        // Settings Modal functions
        function openSettingsModal() {
            document.getElementById('settings-modal').classList.add('open');
        }

        function closeSettingsModal() {
            document.getElementById('settings-modal').classList.remove('open');
        }
        
        // Make modal functions globally available
        window.openAddChallengeModal = openAddChallengeModal;
        window.closeAddChallengeModal = closeAddChallengeModal;
        window.openSettingsModal = openSettingsModal;
        window.closeSettingsModal = closeSettingsModal;

        // Close modal when clicking outside
        document.addEventListener('click', function(event) {
            const addModal = document.getElementById('add-challenge-modal');
            const settingsModal = document.getElementById('settings-modal');
            
            if (event.target === addModal) {
                closeAddChallengeModal();
            }
            if (event.target === settingsModal) {
                closeSettingsModal();
            }
        });

        // Handle form submission success
        document.addEventListener('htmx:afterRequest', function(event) {
            if (event.detail.xhr.status === 200 && event.target.matches('form[hx-post="/api/add-challenge"]')) {
                closeAddChallengeModal();
                // Reset form
                event.target.reset();
                // Refresh challenges by triggering the challenges tab
                htmx.ajax('GET', '/api/content?tab=challenges', {target: '#main-content'});
                // Show success notification
                showNotification('Challenge added successfully!', 'success');
            }
        });
    </script>
</body>
</html>
EOF
