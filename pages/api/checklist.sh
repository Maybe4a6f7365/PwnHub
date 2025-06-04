#!/bin/bash

if [ "$REQUEST_METHOD" = "POST" ]; then
    action="${FORM_DATA[action]}"
    challenge_id="${FORM_DATA[challenge_id]}"
    
    case "$action" in
        "load_template")
            category="${FORM_DATA[category]}"
            
            [ ! -f data/checklists.txt ] && touch data/checklists.txt
            
            if [ -f data/checklists.txt ]; then
                grep -v "^${challenge_id}|" data/checklists.txt > data/checklists_temp.txt
                mv data/checklists_temp.txt data/checklists.txt
            fi
            
            template_items=""
            case "$category" in
                "Web")
                    template_items="SQL Injection|Directory Traversal|XSS (Stored)|XSS (Reflected)|Authentication Bypass|Session Management|CSRF|File Upload Bypass|Command Injection|LDAP Injection|XXE|SSRF|Deserialization"
                    ;;
                "Pwn")
                    template_items="Buffer Overflow|Format String|ROP Chain|Stack Canary Bypass|ASLR Bypass|NX Bypass|Heap Exploitation|Use After Free|Double Free|Integer Overflow|Race Condition|Privilege Escalation|Shellcode Development"
                    ;;
                "Crypto")
                    template_items="Frequency Analysis|Caesar Cipher|Substitution Cipher|Vigenère Cipher|RSA Attack|Weak Keys|Known Plaintext|Chosen Plaintext|Hash Collision|Rainbow Tables|Padding Oracle|Block Cipher Analysis|Stream Cipher Analysis"
                    ;;
                "Forensics")
                    template_items="File Signature Analysis|Metadata Extraction|Steganography|Network Traffic Analysis|Memory Dump Analysis|Disk Image Analysis|Log Analysis|Timeline Analysis|Registry Analysis|Malware Analysis|Deleted File Recovery|Encryption Bypass"
                    ;;
                "Misc")
                    template_items="Source Code Analysis|Logic Puzzle|Encoding/Decoding|OSINT|Social Engineering|Physical Security|Reverse Engineering|Binary Analysis|Protocol Analysis|Custom Algorithm"
                    ;;
                *)
                    template_items="Reconnaissance|Vulnerability Assessment|Exploit Development|Privilege Escalation|Data Extraction|Documentation"
                    ;;
            esac
            
            timestamp=$(date "+%Y-%m-%d %H:%M:%S")
            IFS='|' read -ra ITEMS <<< "$template_items"
            for item in "${ITEMS[@]}"; do
                echo "${challenge_id}|${item}|pending||${timestamp}" >> data/checklists.txt
            done
            
            echo '<div class="success">✓ Template loaded successfully</div>'
            ;;
            
        "add_item")
            item_text="${FORM_DATA[item_text]}"
            assignee="${FORM_DATA[assignee]:-Anonymous}"
            
            if [ -n "$item_text" ]; then
                [ ! -f data/checklists.txt ] && touch data/checklists.txt
                timestamp=$(date "+%Y-%m-%d %H:%M:%S")
                echo "${challenge_id}|${item_text}|pending|${assignee}|${timestamp}" >> data/checklists.txt
                echo '<div class="success">✓ Item added successfully</div>'
            else
                echo '<div class="error">Item text is required</div>'
            fi
            ;;
            
        "update_status")
            item_text="${FORM_DATA[item_text]}"
            new_status="${FORM_DATA[status]}"
            assignee="${FORM_DATA[assignee]:-Anonymous}"
            
            if [ -f data/checklists.txt ]; then
                timestamp=$(date "+%Y-%m-%d %H:%M:%S")
                
                while IFS='|' read -r cid item status old_assignee old_timestamp; do
                    if [ "$cid" = "$challenge_id" ] && [ "$item" = "$item_text" ]; then
                        echo "${cid}|${item}|${new_status}|${assignee}|${timestamp}"
                    else
                        echo "${cid}|${item}|${status}|${old_assignee}|${old_timestamp}"
                    fi
                done < data/checklists.txt > data/checklists_temp.txt
                
                mv data/checklists_temp.txt data/checklists.txt
                echo '<div class="success">✓ Status updated successfully</div>'
            else
                echo '<div class="error">Checklist not found</div>'
            fi
            ;;
            
        *)
            echo '<div class="error">Invalid action</div>'
            ;;
    esac
else
    echo '<div class="error">Only POST requests are allowed</div>'
fi 