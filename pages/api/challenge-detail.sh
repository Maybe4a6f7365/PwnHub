#!/bin/bash

source includes/icons.sh

CHALLENGE_ID="${QUERY_PARAMS[id]}"

get_category_icon() {
    local category="$1"
    case "$category" in
        "Web") echo "$ICON_WEB" ;;
        "Pwn") echo "$ICON_PWN" ;;
        "Crypto") echo "$ICON_CRYPTO" ;;
        "Reverse") echo "$ICON_REVERSE" ;;
        "Forensics") echo "$ICON_FORENSICS" ;;
        "Misc") echo "$ICON_MISC" ;;
        *) echo "$ICON_DEFAULT" ;;
    esac
}

get_checklist_template() {
    local category="$1"
    case "$category" in
        "Web")
            echo "Analyze the source code"
            echo "Check for SQL injection vulnerabilities"
            echo "Test for XSS vulnerabilities"
            echo "Check authentication mechanisms"
            echo "Test for file upload vulnerabilities"
            echo "Check for CSRF protection"
            echo "Analyze cookies and sessions"
            echo "Test for directory traversal"
            echo "Check for remote code execution"
            echo "Verify input validation"
            ;;
        "Pwn")
            echo "Analyze the binary"
            echo "Check for buffer overflow vulnerabilities"
            echo "Identify the protection mechanisms"
            echo "Find the bug"
            echo "Develop exploit strategy"
            echo "Write the exploit"
            echo "Test the exploit locally"
            echo "Get shell access"
            echo "Find the flag"
            ;;
        "Crypto")
            echo "Understand the cryptographic algorithm"
            echo "Identify weaknesses in implementation"
            echo "Analyze the key generation"
            echo "Check for known attack vectors"
            echo "Implement the attack"
            echo "Decrypt/break the cipher"
            echo "Extract the flag"
            ;;
        "Reverse")
            echo "Analyze the binary structure"
            echo "Identify packing/obfuscation"
            echo "Static analysis of the code"
            echo "Dynamic analysis/debugging"
            echo "Understand the algorithm"
            echo "Find the flag or key"
            echo "Bypass any protection mechanisms"
            ;;
        "Forensics")
            echo "Analyze the file structure"
            echo "Check file headers and metadata"
            echo "Look for hidden data"
            echo "Analyze network traffic"
            echo "Check for steganography"
            echo "Recover deleted files"
            echo "Extract relevant information"
            echo "Find the flag"
            ;;
        "Misc")
            echo "Read and understand the challenge"
            echo "Identify the challenge type"
            echo "Research relevant techniques"
            echo "Implement solution approach"
            echo "Test and validate solution"
            echo "Extract the flag"
            ;;
    esac
}

get_status_info() {
    echo "status_class: not-started, status_text: Not Started"
}

CHALLENGE_DATA=""
while IFS='|' read -r id name category difficulty points description flag assignee files tags status; do
    [ -z "$id" ] && continue
    [[ "$id" =~ ^#.* ]] && continue
    if [ "$id" = "$CHALLENGE_ID" ]; then
        CHALLENGE_DATA="$id|$name|$category|$difficulty|$points|$description|$flag|$assignee|$files|$tags|$status"
        break
    fi
done < data/challenges.txt

if [ -z "$CHALLENGE_DATA" ]; then
    echo '<div class="error">Challenge not found</div>'
    exit 1
fi

IFS='|' read -r id name category difficulty points description flag assignee files tags status <<< "$CHALLENGE_DATA"

category_icon=$(get_category_icon "$category")
status_info=$(get_status_info "$status")
status_class=$(echo "$status_info" | cut -d',' -f1 | cut -d':' -f2 | xargs)
status_text=$(echo "$status_info" | cut -d',' -f2 | cut -d':' -f2 | xargs)

if [ -z "$assignee" ]; then
    assignee_display="Unassigned"
else
    assignee_display="$assignee"
fi

case "$difficulty" in
    "Easy"|"easy") difficulty_class="difficulty-easy" ;;
    "Medium"|"medium") difficulty_class="difficulty-medium" ;;
    "Hard"|"hard") difficulty_class="difficulty-hard" ;;
    *) difficulty_class="difficulty-easy" ;;
esac

echo '<div class="challenge-detail-header">'
echo '    <button class="back-btn" onclick="backToDashboard()">'
echo '        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">'
echo '            <path d="M19 12H5"></path>'
echo '            <path d="M12 19l-7-7 7-7"></path>'
echo '        </svg>'
echo '        Back to Dashboard'
echo '    </button>'
echo '    <h2 class="challenge-detail-title">Challenge Details</h2>'
echo '</div>'
echo ''
echo '<div class="challenge-detail-content">'
echo '    <div class="challenge-info-section">'
echo "        <h3 class=\"challenge-name\">${name}</h3>"
echo '        '
echo '        <div class="challenge-meta-row">'
echo '            <div class="challenge-category mb-2">'
echo "                <span class=\"category-icon\">${category_icon}</span>"
echo "                <span>${category}</span>"
echo '            </div>'
echo '            '
echo '            <div class="challenge-points">'
echo "                <strong>${points} points</strong>"
echo '            </div>'
echo '            '
echo "            <div class=\"status-badge ${status_class}\">"
echo "                <span>${status_icon}</span>"
echo "                <span>${status_text}</span>"
echo '            </div>'
echo '        </div>'
echo '        '
echo '        <div class="challenge-details-row">'
echo "            <span class=\"difficulty-badge ${difficulty_class}\">${difficulty}</span>"
echo "            <span class=\"text-muted\">Assigned to: ${assignee_display}</span>"
echo '        </div>'
echo '    </div>'
echo '    '
echo '    <div class="challenge-sections">'
echo '        <div class="left-section">'
echo '            <!-- Challenge Checklist -->'
echo '            <div class="challenge-checklist">'
echo '                <div class="checklist-header">'
echo '                    <label class="form-label">Challenge Checklist</label>'
echo '                    <div class="checklist-actions">'
echo "                        <button class=\"btn-small btn-secondary\" onclick=\"loadChecklistTemplate('${category}', '${id}')\">"
echo "                            Load ${category} Template"
echo '                        </button>'
echo "                        <button class=\"btn-small btn-primary\" onclick=\"addCustomChecklistItem('${id}')\">"
echo '                            Add Custom Item'
echo '                        </button>'
echo '                    </div>'
echo '                </div>'
echo '                '
echo "                <div id=\"checklist-${id}\" class=\"checklist-container\">"

if [ -f data/checklists.txt ]; then
    while IFS='|' read -r checklist_challenge_id item_text status assignee timestamp; do
        [ -z "$checklist_challenge_id" ] && continue
        if [ "$checklist_challenge_id" = "$id" ]; then
            status_class=""
            status_icon=""
            case "$status" in
                "completed") status_class="status-completed"; status_icon="✓" ;;
                "failed") status_class="status-failed"; status_icon="✗" ;;
                "in-progress") status_class="status-in-progress"; status_icon="⧖" ;;
                *) status_class="status-pending"; status_icon="○" ;;
            esac
            echo "            <div class=\"checklist-item ${status_class}\" data-item=\"${item_text}\">"
            echo '                <div class="checklist-content">'
            echo "                    <span class=\"checklist-icon\">${status_icon}</span>"
            echo "                    <span class=\"checklist-text\">${item_text}</span>"
            echo '                    <div class="checklist-meta">'
            echo "                        <span class=\"checklist-assignee\">${assignee:-"Unassigned"}</span>"
            echo "                        <span class=\"checklist-timestamp\">${timestamp}</span>"
            echo '                    </div>'
            echo '                </div>'
            echo '                <div class="checklist-controls">'
            echo "                    <button class=\"status-btn completed\" onclick=\"updateChecklistStatus('${id}', '${item_text}', 'completed')\" title=\"Mark as Completed\">✓</button>"
            echo "                    <button class=\"status-btn failed\" onclick=\"updateChecklistStatus('${id}', '${item_text}', 'failed')\" title=\"Mark as Failed\">✗</button>"
            echo "                    <button class=\"status-btn in-progress\" onclick=\"updateChecklistStatus('${id}', '${item_text}', 'in-progress')\" title=\"Mark as In Progress\">⧖</button>"
            echo "                    <button class=\"status-btn pending\" onclick=\"updateChecklistStatus('${id}', '${item_text}', 'pending')\" title=\"Mark as Pending\">○</button>"
            echo '                </div>'
            echo '            </div>'
        fi
    done < data/checklists.txt
fi

echo '                </div>'
echo '                '
echo "                <div class=\"add-checklist-item\" style=\"display: none;\" id=\"add-item-${id}\">"
echo "                    <form id=\"checklist-form-${id}\" onsubmit=\"submitChecklistItem(event, '${id}')\">"
echo '                        <input type="hidden" name="action" value="add_item">'
echo "                        <input type=\"hidden\" name=\"challenge_id\" value=\"${id}\">"
echo "                        <input type=\"text\" name=\"item_text\" class=\"form-input\" placeholder=\"Enter checklist item...\" id=\"new-item-${id}\" required>"
echo '                        <input type="hidden" name="assignee" value="Anonymous">'
echo '                        <div class="flex gap-2 mt-2">'
echo '                            <button type="submit" class="btn btn-success">Add Item</button>'
echo "                            <button type=\"button\" class=\"btn btn-secondary\" onclick=\"cancelAddItem('${id}')\">Cancel</button>"
echo '                        </div>'
echo '                    </form>'
echo '                </div>'
echo '            </div>'
echo '            '
echo '            <!-- Script & File Uploads -->'
echo '            <div class="form-group">'
echo '                <label class="form-label">Script & File Uploads</label>'
echo '                <div class="upload-section">'
echo "                    <div class=\"upload-area\" onclick=\"document.getElementById('file-upload-${id}').click()\">"
echo '                        <div class="upload-icon">📁</div>'
echo '                        <div class="upload-text">'
echo '                            <strong>Click to upload scripts, tools, or findings</strong>'
echo '                            <br><small>Supports: .py, .sh, .txt, .md, .zip, .tar.gz (Max: 10MB)</small>'
echo '                        </div>'
echo '                    </div>'
echo "                    <input type=\"file\" id=\"file-upload-${id}\" style=\"display: none;\" "
echo '                           accept=".py,.sh,.txt,.md,.zip,.tar.gz,.js,.php,.c,.cpp,.java,.rb,.go" '
echo "                           multiple onchange=\"uploadFiles('${id}', this.files)\">"
echo '                </div>'
echo '                '
echo "                <div id=\"uploaded-files-${id}\" class=\"uploaded-files\">"

if [ -f data/uploads.txt ]; then
    while IFS='|' read -r upload_challenge_id filename uploader upload_time file_size; do
        [ -z "$upload_challenge_id" ] && continue
        if [ "$upload_challenge_id" = "$id" ]; then
            file_icon="📄"
            case "${filename##*.}" in
                "py") file_icon="🐍" ;;
                "sh") file_icon="🐚" ;;
                "js") file_icon="🟨" ;;
                "zip"|"tar"|"gz") file_icon="📦" ;;
                "txt"|"md") file_icon="📝" ;;
            esac
            echo '            <div class="uploaded-file">'
            echo '                <div class="file-info">'
            echo "                    <span class=\"file-icon\">${file_icon}</span>"
            echo '                    <div class="file-details">'
            echo "                        <span class=\"file-name\">${filename}</span>"
            echo '                        <div class="file-meta">'
            echo "                            <span>by ${uploader}</span> • "
            echo "                            <span>${upload_time}</span> • "
            echo "                            <span>${file_size}</span>"
            echo '                        </div>'
            echo '                    </div>'
            echo '                </div>'
            echo '                <div class="file-actions">'
            echo "                    <button class=\"btn-small btn-primary\" onclick=\"downloadFile('${id}', '${filename}')\">Download</button>"
            echo "                    <button class=\"btn-small btn-secondary\" onclick=\"viewFile('${id}', '${filename}')\">View</button>"
            echo '                </div>'
            echo '            </div>'
        fi
    done < data/uploads.txt
fi

echo '                </div>'
echo '            </div>'
echo '        </div>'
echo '        '
echo '        <div class="right-section">'
echo '            <!-- Team Notes -->'
echo '            <div class="form-group">'
echo '                <label class="form-label">Team Notes</label>'
echo '                <div class="notes-section">'
echo "                    <textarea id=\"team-notes-${id}\" class=\"form-input textarea\" "
echo '                              placeholder="Add notes about this challenge..." '
echo "                              rows=\"4\" onblur=\"saveTeamNotes('${id}')\"></textarea>"
echo '                    <div class="notes-meta">'
echo '                        <small class="text-muted">Notes auto-save when you click outside the text area</small>'
echo '                    </div>'
echo '                </div>'
echo '            </div>'
echo '            '
echo '            <!-- Submitted Flags & Notes -->'
echo '            <div class="form-group">'
echo '                <label class="form-label">Submitted Flags & Notes</label>'
echo "                <div class=\"submitted-flags\" id=\"submitted-flags-${id}\">"

if [ -f data/flags.txt ]; then
    flags_found=false
    while IFS='|' read -r flag_challenge_id flag_content submitter timestamp; do
        [ -z "$flag_challenge_id" ] && continue
        if [ "$flag_challenge_id" = "$id" ]; then
            flags_found=true
            echo '            <div class="flag-entry">'
            echo '                <div class="flag-header">'
            echo "                    <span class=\"flag-submitter\">${submitter}</span>"
            echo "                    <span class=\"flag-timestamp\">${timestamp}</span>"
            echo '                </div>'
            echo "                <div class=\"flag-content\">${flag_content}</div>"
            echo '            </div>'
        fi
    done < data/flags.txt
    
    if [ "$flags_found" = "false" ]; then
        echo '            <div class="no-flags-message">'
        echo '                <p class="text-muted">No flags or notes have been submitted for this challenge yet.</p>'
        echo '                <p class="text-muted">Be the first to share your findings!</p>'
        echo '            </div>'
    fi
else
    echo '            <div class="no-flags-message">'
    echo '                <p class="text-muted">No flags or notes have been submitted for this challenge yet.</p>'
    echo '                <p class="text-muted">Be the first to share your findings!</p>'
    echo '            </div>'
fi

echo '                </div>'
echo '            </div>'
echo '            '
echo '            <!-- Flag Submission -->'
echo '            <div class="form-group">'
echo '                <label class="form-label">Flag Submission</label>'
echo "                <form id=\"flag-form-${id}\" onsubmit=\"submitFlag(event, '${id}')\">"
echo "                    <input type=\"hidden\" name=\"challenge_id\" value=\"${id}\">"
echo '                    <div class="flex gap-2">'
echo '                        <input type="text" '
echo '                               name="flag" '
echo '                               class="form-input" '
echo '                               placeholder="flag{example_flag_here} or any notes/findings" '
echo '                               style="flex: 1;" required>'
echo '                        <input type="text" '
echo '                               name="submitter" '
echo '                               class="form-input" '
echo '                               placeholder="Your name" '
echo '                               style="width: 150px;">'
echo '                        <button type="submit" class="btn btn-success">'
echo "                            ${FLAG_ICON}"
echo '                            <span>Submit</span>'
echo '                        </button>'
echo '                    </div>'
echo '                </form>'
echo "                <div id=\"flag-result-${id}\" class=\"mt-2\"></div>"
echo '            </div>'
echo '        </div>'
echo '    </div>'
echo '    '
echo '    <script>'
echo '        // Load existing notes when the page loads'
echo '        setTimeout(() => {'
echo "            fetch('/api/team-notes?challenge_id=${id}')"
echo '                .then(response => response.text())'
echo '                .then(notes => {'
echo "                    const notesTextarea = document.getElementById('team-notes-${id}');"
echo "                    if (notesTextarea && notes && !notes.includes('error') && notes.trim() !== '') {"
echo '                        notesTextarea.value = notes.trim();'
echo '                    }'
echo '                })'
echo "                .catch(error => {});"
echo '        }, 100);'
echo '    </script>'
echo '</div>' 