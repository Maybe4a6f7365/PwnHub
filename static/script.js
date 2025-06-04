// PwnHub - Cyberpunk CTF Collaboration Platform
let currentChallengeId = null;

function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    notification.textContent = message;
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.classList.add('show');
    }, 100);
    
    setTimeout(() => {
        notification.classList.remove('show');
        setTimeout(() => {
            document.body.removeChild(notification);
        }, 300);
    }, 3000);
}

function loadChecklistTemplate(category, challengeId) {
    const params = new URLSearchParams();
    params.append('action', 'load_template');
    params.append('category', category);
    params.append('challenge_id', challengeId);
    
    fetch('/api/checklist', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params
    })
    .then(response => response.text())
    .then(html => {
        if (html.includes('success')) {
            showNotification(`${category} template loaded successfully!`, 'success');
            refreshChallengeDetail(challengeId);
        } else {
            showNotification('Error loading template', 'error');
        }
    })
    .catch(error => {
        showNotification('Error loading template', 'error');
    });
}

function addCustomChecklistItem(challengeId) {
    const addItemDiv = document.getElementById(`add-item-${challengeId}`);
    if (!addItemDiv) {
        showNotification('Error: Add item form not found', 'error');
        return;
    }
    addItemDiv.style.display = 'block';
    const inputField = document.getElementById(`new-item-${challengeId}`);
    if (inputField) {
        inputField.focus();
    }
}

function saveCustomChecklistItem(challengeId) {
    const itemText = document.getElementById(`new-item-${challengeId}`).value.trim();
    if (!itemText) {
        showNotification('Please enter an item description', 'error');
        return;
    }
    
    const params = new URLSearchParams();
    params.append('action', 'add_item');
    params.append('challenge_id', challengeId);
    params.append('item_text', itemText);
    params.append('assignee', 'Anonymous');
    
    fetch('/api/checklist', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params
    })
    .then(response => response.text())
    .then(html => {
        if (html.includes('success')) {
            showNotification('Item added successfully!', 'success');
            cancelAddItem(challengeId);
            refreshChallengeDetail(challengeId);
        } else {
            showNotification('Error adding item', 'error');
        }
    })
    .catch(error => {
        showNotification('Error adding item', 'error');
    });
}

function cancelAddItem(challengeId) {
    const addItemDiv = document.getElementById(`add-item-${challengeId}`);
    addItemDiv.style.display = 'none';
    document.getElementById(`new-item-${challengeId}`).value = '';
}

function submitChecklistItem(event, challengeId) {
    event.preventDefault();
    
    const form = event.target;
    const formData = new FormData(form);
    
    const params = new URLSearchParams();
    for (let [key, value] of formData.entries()) {
        params.append(key, value);
    }
    
    fetch('/api/checklist', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params
    })
    .then(response => response.text())
    .then(html => {
        if (html.includes('success')) {
            showNotification('Item added successfully!', 'success');
            cancelAddItem(challengeId);
            refreshChallengeDetail(challengeId);
        } else {
            showNotification('Error adding item', 'error');
        }
    })
    .catch(error => {
        showNotification('Error adding item', 'error');
    });
}

function updateChecklistStatus(challengeId, itemText, status) {
    const params = new URLSearchParams();
    params.append('action', 'update_status');
    params.append('challenge_id', challengeId);
    params.append('item_text', itemText);
    params.append('status', status);
    params.append('assignee', 'Anonymous');
    
    fetch('/api/checklist', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params
    })
    .then(response => response.text())
    .then(html => {
        if (html.includes('success')) {
            showNotification(`Marked as ${status}`, 'success');
            refreshChallengeDetail(challengeId);
        } else {
            showNotification('Error updating status', 'error');
        }
    })
    .catch(error => {
        showNotification('Error updating status', 'error');
    });
}

function uploadFiles(challengeId, files) {
    if (!files || files.length === 0) {
        return;
    }
    
    for (let file of files) {
        if (file.size > 10 * 1024 * 1024) {
            showNotification(`File ${file.name} is too large (max 10MB)`, 'error');
            continue;
        }
        
        const reader = new FileReader();
        reader.onload = function(e) {
            const params = new URLSearchParams();
            params.append('challenge_id', challengeId);
            params.append('filename', file.name);
            params.append('content', e.target.result);
            params.append('uploader', 'Anonymous');
            
            fetch('/api/upload', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: params
            })
            .then(response => response.text())
            .then(html => {
                if (html.includes('success')) {
                    showNotification(`File ${file.name} uploaded successfully!`, 'success');
                    refreshChallengeDetail(challengeId);
                } else {
                    showNotification(`Error uploading ${file.name}`, 'error');
                }
            })
            .catch(error => {
                showNotification('Error uploading file', 'error');
            });
        };
        
        reader.readAsText(file);
    }
}

function downloadFile(challengeId, filename) {
    const link = document.createElement('a');
    link.href = `/uploads/${challengeId}/${filename}`;
    link.download = filename;
    link.click();
    showNotification(`Downloading ${filename}`, 'info');
}

function viewFile(challengeId, filename) {
    let modal = document.getElementById('code-viewer-modal');
    if (!modal) {
        modal = document.createElement('div');
        modal.id = 'code-viewer-modal';
        modal.className = 'code-modal';
        modal.innerHTML = `
            <div class="code-modal-content">
                <div class="code-modal-header">
                    <h3 id="code-modal-title"></h3>
                    <button class="code-modal-close" onclick="closeCodeViewer()">&times;</button>
                </div>
                <div class="code-modal-body">
                    <pre id="code-content"><code id="code-text"></code></pre>
                </div>
                <div class="code-modal-footer">
                    <button class="btn btn-primary" onclick="downloadFile('${challengeId}', document.getElementById('code-modal-title').dataset.filename)">
                        Download File
                    </button>
                    <button class="btn btn-secondary" onclick="closeCodeViewer()">
                        Close
                    </button>
                </div>
            </div>
        `;
        document.body.appendChild(modal);
    }
    
    const titleElement = document.getElementById('code-modal-title');
    titleElement.textContent = filename;
    titleElement.dataset.filename = filename;
    
    const codeText = document.getElementById('code-text');
    codeText.textContent = 'Loading...';
    
    modal.style.display = 'flex';
    
    fetch(`/uploads/${challengeId}/${filename}`)
        .then(response => response.text())
        .then(content => {
            codeText.textContent = content;
            applySyntaxHighlighting(filename, codeText);
        })
        .catch(error => {
            codeText.textContent = 'Error loading file content.';
            showNotification('Error loading file', 'error');
        });
}

function closeCodeViewer() {
    const modal = document.getElementById('code-viewer-modal');
    if (modal) {
        modal.style.display = 'none';
    }
}

function applySyntaxHighlighting(filename, codeElement) {
    const extension = filename.split('.').pop().toLowerCase();
    
    codeElement.className = '';
    
    switch (extension) {
        case 'py':
            codeElement.className = 'language-python';
            break;
        case 'js':
            codeElement.className = 'language-javascript';
            break;
        case 'sh':
            codeElement.className = 'language-bash';
            break;
        case 'php':
            codeElement.className = 'language-php';
            break;
        case 'c':
        case 'cpp':
            codeElement.className = 'language-c';
            break;
        case 'java':
            codeElement.className = 'language-java';
            break;
        case 'rb':
            codeElement.className = 'language-ruby';
            break;
        case 'go':
            codeElement.className = 'language-go';
            break;
        case 'md':
            codeElement.className = 'language-markdown';
            break;
        default:
            codeElement.className = 'language-text';
    }
}

function refreshChallengeDetail(challengeId) {
    if (currentChallengeId === challengeId) {
        loadChallengeDetail(challengeId);
    }
}

function loadChallengeDetail(challengeId) {
    currentChallengeId = challengeId;
    
    const challengesGrid = document.querySelector('.challenges-grid');
    const contentHeader = document.querySelector('.content-header');
    
    if (challengesGrid) {
        challengesGrid.style.display = 'none';
    }
    if (contentHeader) {
        contentHeader.style.display = 'none';
    }
    
    let challengeDetailContainer = document.getElementById('challenge-detail-container');
    if (!challengeDetailContainer) {
        challengeDetailContainer = document.createElement('div');
        challengeDetailContainer.id = 'challenge-detail-container';
        challengeDetailContainer.className = 'challenge-detail-container';
        document.querySelector('.main-content').appendChild(challengeDetailContainer);
    }
    
    challengeDetailContainer.innerHTML = `
        <div class="loading-container">
            <div class="loading-spinner"></div>
            <p>Loading challenge details...</p>
        </div>
    `;
    challengeDetailContainer.style.display = 'block';
    
    fetch(`/api/challenge-detail?id=${challengeId}`)
        .then(response => response.text())
        .then(html => {
            challengeDetailContainer.innerHTML = html;
            
            const loadNotesWithRetry = (attemptNumber = 1, maxAttempts = 10) => {
                const notesTextarea = document.getElementById(`team-notes-${challengeId}`);
                if (notesTextarea) {
                    loadTeamNotesForChallenge(challengeId);
                } else if (attemptNumber < maxAttempts) {
                    setTimeout(() => {
                        loadNotesWithRetry(attemptNumber + 1, maxAttempts);
                    }, attemptNumber * 100);
                }
            };
            
            loadNotesWithRetry();
            
            setTimeout(() => {
                const items = document.querySelectorAll('.checklist-item, .uploaded-file, .flag-entry');
                items.forEach((item, index) => {
                    item.style.animationDelay = `${index * 0.05}s`;
                    item.classList.add('fade-in-up');
                });
            }, 100);
        })
        .catch(error => {
            challengeDetailContainer.innerHTML = `
                <div class="error-container">
                    <h2>Error Loading Challenge</h2>
                    <p>Failed to load challenge details. Please try again.</p>
                    <button class="btn btn-primary" onclick="backToDashboard()">Back to Dashboard</button>
                </div>
            `;
            showNotification('Error loading challenge details', 'error');
        });
}

function loadTeamNotesForChallenge(challengeId) {
    const notesTextarea = document.getElementById(`team-notes-${challengeId}`);
    
    if (!notesTextarea) {
        return;
    }
    
    fetch(`/api/team-notes?challenge_id=${challengeId}`)
        .then(response => response.text())
        .then(notes => {
            if (notes && !notes.includes('error') && notes.trim() !== '') {
                notesTextarea.value = notes.trim();
                showNotification('Team notes loaded', 'success');
            }
        })
        .catch(error => {
        });
}

function backToDashboard() {
    const challengeDetailContainer = document.getElementById('challenge-detail-container');
    if (challengeDetailContainer) {
        challengeDetailContainer.style.display = 'none';
    }
    
    const challengesGrid = document.querySelector('.challenges-grid');
    const contentHeader = document.querySelector('.content-header');
    
    if (challengesGrid) {
        challengesGrid.style.display = 'grid';
        setTimeout(() => {
            const cards = document.querySelectorAll('.challenge-card');
            cards.forEach((card, index) => {
                card.style.animationDelay = `${index * 0.05}s`;
                card.classList.add('slide-in-right');
            });
        }, 100);
    }
    if (contentHeader) {
        contentHeader.style.display = 'flex';
    }
    
    currentChallengeId = null;
    
    showNotification('Returned to dashboard', 'info');
}

function initializeEnhancedUI() {
    const challengeCards = document.querySelectorAll('.challenge-card');
    challengeCards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-5px) scale(1.02)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0) scale(1)';
        });
    });
    
    const searchInput = document.querySelector('.search-input');
    if (searchInput) {
        searchInput.addEventListener('focus', function() {
            this.style.boxShadow = '0 0 30px rgba(255, 107, 53, 0.4), inset 0 0 20px rgba(255, 107, 53, 0.1)';
        });
        
        searchInput.addEventListener('blur', function() {
            this.style.boxShadow = '';
        });
    }
    
    const buttons = document.querySelectorAll('.btn');
    buttons.forEach(button => {
        button.addEventListener('click', function() {
            this.style.transform = 'scale(0.95)';
            setTimeout(() => {
                this.style.transform = '';
            }, 150);
        });
    });
    
    initializeTooltips();
}

function initializeTooltips() {
    const tooltipElements = document.querySelectorAll('[title]');
    tooltipElements.forEach(element => {
        const title = element.getAttribute('title');
        if (title) {
            element.removeAttribute('title');
            element.classList.add('tooltip');
            
            const tooltipText = document.createElement('span');
            tooltipText.className = 'tooltiptext';
            tooltipText.textContent = title;
            element.appendChild(tooltipText);
        }
    });
}

function updateProgress(challengeId) {
    const checklistItems = document.querySelectorAll(`[data-challenge-id="${challengeId}"] .checklist-item`);
    const completedItems = document.querySelectorAll(`[data-challenge-id="${challengeId}"] .checklist-item.status-completed`);
    
    if (checklistItems.length > 0) {
        const progress = (completedItems.length / checklistItems.length) * 100;
        const progressBar = document.querySelector(`[data-challenge-id="${challengeId}"] .progress-fill`);
        if (progressBar) {
            progressBar.style.width = `${progress}%`;
        }
    }
}

function enhanceSearch() {
    const searchInput = document.querySelector('.search-input');
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            const query = this.value.toLowerCase();
            const challengeCards = document.querySelectorAll('.challenge-card');
            
            challengeCards.forEach(card => {
                const title = card.querySelector('.challenge-name').textContent.toLowerCase();
                const category = card.querySelector('.challenge-category').textContent.toLowerCase();
                const tags = Array.from(card.querySelectorAll('.tag')).map(tag => tag.textContent.toLowerCase());
                
                const matches = title.includes(query) || 
                              category.includes(query) || 
                              tags.some(tag => tag.includes(query));
                
                if (matches || query === '') {
                    card.style.display = 'block';
                    card.style.animation = 'fadeInUp 0.5s ease';
                } else {
                    card.style.display = 'none';
                }
            });
        });
    }
}

function initializeKeyboardShortcuts() {
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            if (currentChallengeId) {
                backToDashboard();
            }
        }
        
        if (e.ctrlKey && e.key === 'f') {
            e.preventDefault();
            if (!currentChallengeId) {
                const searchInput = document.querySelector('.search-input');
                if (searchInput) {
                    searchInput.focus();
                }
            }
        }
    });
}

document.addEventListener('DOMContentLoaded', function() {
    initializeEnhancedUI();
    enhanceSearch();
    initializeKeyboardShortcuts();
    
    setTimeout(() => {
        const elements = document.querySelectorAll('.challenge-card, .team-member, .nav-link');
        elements.forEach((element, index) => {
            element.style.animationDelay = `${index * 0.1}s`;
            element.classList.add('slide-in-right');
        });
    }, 500);
    
    showNotification('Welcome to PwnHub! CTF collaboration platform loaded.', 'success');
});

window.loadChecklistTemplate = loadChecklistTemplate;
window.addCustomChecklistItem = addCustomChecklistItem;
window.saveCustomChecklistItem = saveCustomChecklistItem;
window.submitChecklistItem = submitChecklistItem;
window.cancelAddItem = cancelAddItem;
window.updateChecklistStatus = updateChecklistStatus;
window.uploadFiles = uploadFiles;
window.downloadFile = downloadFile;
window.viewFile = viewFile;
window.loadChallengeDetail = loadChallengeDetail;
window.backToDashboard = backToDashboard;
window.saveTeamNotes = saveTeamNotes;
window.submitFlag = submitFlag;
window.closeCodeViewer = closeCodeViewer;

function saveTeamNotes(challengeId) {
    const notesTextarea = document.getElementById(`team-notes-${challengeId}`);
    
    if (!notesTextarea) {
        return;
    }
    
    const notes = notesTextarea.value.trim();
    
    const params = new URLSearchParams();
    params.append('challenge_id', challengeId);
    params.append('notes', notes);
    params.append('editor', 'Anonymous');
    
    fetch('/api/team-notes', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params
    })
    .then(response => response.text())
    .then(html => {
        if (html.includes('success')) {
            showNotification('Team notes saved successfully!', 'success');
        } else {
            showNotification('Error saving notes', 'error');
        }
    })
    .catch(error => {
        showNotification('Error saving notes', 'error');
    });
}

function submitFlag(event, challengeId) {
    event.preventDefault();
    
    const form = event.target;
    const formData = new FormData(form);
    
    const params = new URLSearchParams();
    for (let [key, value] of formData.entries()) {
        params.append(key, value);
    }
    
    fetch('/api/submit-flag', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params
    })
    .then(response => response.text())
    .then(html => {
        const resultDiv = document.getElementById(`flag-result-${challengeId}`);
        resultDiv.innerHTML = html;
        
        if (html.includes('success')) {
            showNotification('Flag submitted successfully!', 'success');
            form.reset();
            setTimeout(() => {
                refreshChallengeDetail(challengeId);
            }, 1000);
        } else {
            showNotification('Error submitting flag', 'error');
        }
    })
    .catch(error => {
        showNotification('Error submitting flag', 'error');
    });
}

function openAddChallengeModal() {
    const modal = document.getElementById('add-challenge-modal');
    if (modal) {
        modal.classList.add('open');
        document.body.style.overflow = 'hidden';
    }
}

function closeAddChallengeModal() {
    const modal = document.getElementById('add-challenge-modal');
    if (modal) {
        modal.classList.remove('open');
        document.body.style.overflow = 'auto';
        const form = modal.querySelector('form');
        if (form) form.reset();
        const response = document.getElementById('challenge-response');
        if (response) response.innerHTML = '';
    }
}

window.openAddChallengeModal = openAddChallengeModal;
window.closeAddChallengeModal = closeAddChallengeModal;

function openSettingsModal() {
    const modal = document.getElementById('settings-modal');
    if (modal) {
        modal.classList.add('open');
        document.body.style.overflow = 'hidden';
    }
}

function closeSettingsModal() {
    const modal = document.getElementById('settings-modal');
    if (modal) {
        modal.classList.remove('open');
        document.body.style.overflow = 'auto';
        const form = modal.querySelector('form');
        if (form) form.reset();
        const response = document.getElementById('settings-response');
        if (response) response.innerHTML = '';
    }
}

window.openSettingsModal = openSettingsModal;
window.closeSettingsModal = closeSettingsModal;

document.addEventListener('click', function(event) {
    const challengeModal = document.getElementById('add-challenge-modal');
    const settingsModal = document.getElementById('settings-modal');
    
    if (event.target === challengeModal) {
        closeAddChallengeModal();
    }
    
    if (event.target === settingsModal) {
        closeSettingsModal();
    }
});

function deleteChallenge(challengeId, event) {
    event.stopPropagation();
    
    if (confirm('Are you sure you want to delete this challenge? This action cannot be undone.')) {
        const params = new URLSearchParams();
        params.append('challenge_id', challengeId);
        
        fetch('/api/delete-challenge', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: params
        })
        .then(response => response.text())
        .then(html => {
            if (html.includes('success')) {
                showNotification('Challenge deleted successfully!', 'success');
                htmx.ajax('GET', '/api/content?tab=challenges', {target: '#main-content'});
            } else {
                showNotification('Error deleting challenge', 'error');
            }
        })
        .catch(error => {
            showNotification('Error deleting challenge', 'error');
        });
    }
}

function searchChallenges(query) {
    const cards = document.querySelectorAll('.challenge-card');
    const lowercaseQuery = query.toLowerCase();
    
    cards.forEach(card => {
        const name = card.querySelector('.challenge-name').textContent.toLowerCase();
        const category = card.querySelector('.challenge-category span:last-child').textContent.toLowerCase();
        const tags = Array.from(card.querySelectorAll('.tag')).map(tag => tag.textContent.toLowerCase()).join(' ');
        
        const matches = name.includes(lowercaseQuery) || 
                       category.includes(lowercaseQuery) || 
                       tags.includes(lowercaseQuery);
        
        if (matches || query === '') {
            card.style.display = 'block';
            card.style.animation = 'fadeInUp 0.3s ease';
        } else {
            card.style.display = 'none';
        }
    });
}

window.deleteChallenge = deleteChallenge;
window.searchChallenges = searchChallenges; 