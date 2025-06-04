#!/bin/bash

# JSON Formatter Tool

JSON_INPUT="${FORM_DATA["json-input"]}"
OPERATION="${FORM_DATA["operation"]}"

if [[ -z "$JSON_INPUT" ]]; then
    echo "<div class='tool-error'>Please enter JSON data to process</div>"
    exit 0
fi

validate_json() {
    local json="$1"
    echo "$json" | python3 -m json.tool >/dev/null 2>&1
    return $?
}

format_json() {
    local json="$1"
    echo "$json" | python3 -m json.tool 2>/dev/null
}

minify_json() {
    local json="$1"
    echo "$json" | python3 -c "import sys, json; print(json.dumps(json.load(sys.stdin), separators=(',', ':')))" 2>/dev/null
}

echo "<div class='tool-result'>"
echo "<h4>JSON Formatter Results</h4>"
echo "<div class='json-results'>"

echo "<strong>Original Input:</strong><br>"
echo "<div class='json-box original'><pre>$JSON_INPUT</pre></div><br>"

if validate_json "$JSON_INPUT"; then
    echo "✅ <span class='validation-success'>Valid JSON</span><br><br>"
    
    case "$OPERATION" in
        "format")
            echo "<strong>Formatted JSON:</strong><br>"
            formatted=$(format_json "$JSON_INPUT")
            if [[ -n "$formatted" ]]; then
                echo "<div class='json-box formatted'><pre>$formatted</pre></div>"
                
                echo "<br><strong>JSON Analysis:</strong><br>"
                echo "<div class='analysis-info'>"
                
                object_count=$(echo "$formatted" | grep -c '{')
                array_count=$(echo "$formatted" | grep -c '\[')
                string_count=$(echo "$formatted" | grep -o '"[^"]*"' | wc -l)
                number_count=$(echo "$formatted" | grep -oE '\b[0-9]+(\.[0-9]+)?\b' | wc -l)
                
                echo "📊 <strong>Structure:</strong><br>"
                echo "• Objects: $object_count<br>"
                echo "• Arrays: $array_count<br>"
                echo "• Strings: $string_count<br>"
                echo "• Numbers: $number_count<br>"
                
                original_size=${#JSON_INPUT}
                formatted_size=${#formatted}
                echo "<br>📏 <strong>Size:</strong><br>"
                echo "• Original: $original_size characters<br>"
                echo "• Formatted: $formatted_size characters<br>"
                
                echo "</div>"
            else
                echo "<div class='tool-error'>Error formatting JSON</div>"
            fi
            ;;
            
        "minify")
            echo "<strong>Minified JSON:</strong><br>"
            minified=$(minify_json "$JSON_INPUT")
            if [[ -n "$minified" ]]; then
                echo "<div class='json-box minified'><pre>$minified</pre></div>"
                
                echo "<br><strong>Size Comparison:</strong><br>"
                echo "<div class='size-comparison'>"
                original_size=${#JSON_INPUT}
                minified_size=${#minified}
                savings=$((original_size - minified_size))
                percentage=$((savings * 100 / original_size))
                
                echo "📊 Original: $original_size characters<br>"
                echo "📊 Minified: $minified_size characters<br>"
                echo "💾 Space saved: $savings characters ($percentage%)<br>"
                echo "</div>"
            else
                echo "<div class='tool-error'>Error minifying JSON</div>"
            fi
            ;;
            
        "validate")
            echo "<strong>JSON Validation Results:</strong><br>"
            echo "<div class='validation-details'>"
            echo "✅ <span class='validation-success'>JSON is valid!</span><br><br>"
            
            echo "<strong>Detailed Analysis:</strong><br>"
            
            structure=$(echo "$JSON_INPUT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    def analyze(obj, depth=0):
        indent = '  ' * depth
        if isinstance(obj, dict):
            print(f'{indent}Object with {len(obj)} keys:')
            for key in list(obj.keys())[:5]:  # Show first 5 keys
                print(f'{indent}  - {key}: {type(obj[key]).__name__}')
            if len(obj) > 5:
                print(f'{indent}  ... and {len(obj)-5} more keys')
        elif isinstance(obj, list):
            print(f'{indent}Array with {len(obj)} elements')
            if obj:
                print(f'{indent}  Element type: {type(obj[0]).__name__}')
        elif isinstance(obj, str):
            print(f'{indent}String: \"{obj[:50]}{'...' if len(obj) > 50 else ''}\"')
        elif isinstance(obj, (int, float)):
            print(f'{indent}Number: {obj}')
        elif isinstance(obj, bool):
            print(f'{indent}Boolean: {obj}')
        elif obj is None:
            print(f'{indent}Null')
    
    analyze(data)
except Exception as e:
    print(f'Error: {e}')
" 2>/dev/null)
            
            echo "<div class='structure-analysis'><pre>$structure</pre></div>"
            echo "</div>"
            ;;
    esac
    
else
    echo "❌ <span class='validation-error'>Invalid JSON</span><br><br>"
    
    echo "<strong>Validation Errors:</strong><br>"
    echo "<div class='error-details'>"
    
    error_output=$(echo "$JSON_INPUT" | python3 -m json.tool 2>&1 | tail -n 5)
    echo "<pre class='error-message'>$error_output</pre>"
    
    echo "<br><strong>Common JSON Issues:</strong><br>"
    echo "<ul class='common-issues'>"
    echo "<li>Missing quotes around strings</li>"
    echo "<li>Trailing commas after last element</li>"
    echo "<li>Single quotes instead of double quotes</li>"
    echo "<li>Unclosed brackets or braces</li>"
    echo "<li>Invalid escape sequences</li>"
    echo "</ul>"
    echo "</div>"
fi

echo "</div>"
echo "</div>"