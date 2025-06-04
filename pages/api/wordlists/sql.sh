#!/bin/bash
# headers

# Check if the SQL wordlist file exists
if [[ ! -f "data/sql.txt" ]]; then
    respond 404 "Not Found"
    header Content-Type "text/plain"
    end_headers
    echo "SQL wordlist file not found"
    exit 0
fi

# Serve the file with appropriate headers for download
respond 200 "OK"
header Content-Type "text/plain"
header Content-Disposition "attachment; filename=\"sql-payloads.txt\""
header Content-Length "$(stat -c%s data/sql.txt)"
end_headers

cat data/sql.txt 