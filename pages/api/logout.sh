#!/bin/bash

if [ "$REQUEST_METHOD" = "POST" ]; then
    SESSION["authenticated"]=""
    SESSION["username"]=""
    SESSION["display_name"]=""
    SESSION["specialty"]=""
    SESSION["login_time"]=""
    save_session
    
    echo '<div class="success">✓ Logged out successfully</div>'
    echo '<script>setTimeout(() => { window.location.reload(); }, 500);</script>'
else
    echo '<div class="error">Invalid request method</div>'
fi 