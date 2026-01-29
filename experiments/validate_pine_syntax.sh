#!/bin/bash
# Simple Pine Script syntax validator
# Checks for common syntax issues

FILE="$1"

if [ ! -f "$FILE" ]; then
    echo "File not found: $FILE"
    exit 1
fi

echo "Validating Pine Script syntax for: $FILE"
echo "================================================"

# Check for basic Pine Script structure
if ! grep -q "^//@version=" "$FILE"; then
    echo "ERROR: Missing @version directive"
    exit 1
else
    echo "✓ @version directive found"
fi

if ! grep -q "^indicator(" "$FILE" && ! grep -q "^strategy(" "$FILE"; then
    echo "ERROR: Missing indicator() or strategy() declaration"
    exit 1
else
    echo "✓ indicator() declaration found"
fi

# Check for common syntax issues
echo ""
echo "Checking for common syntax issues:"

# Check for undeclared variables being assigned
if grep -E "^\s+[a-zA-Z_][a-zA-Z0-9_]*\s*=" "$FILE" | grep -v "var\|float\|int\|bool\|string\|color" | head -5; then
    echo "Note: Found variable assignments (may be OK if already declared)"
fi

# Count function definitions
func_count=$(grep -c "^[a-zA-Z_][a-zA-Z0-9_]*([^)]*)\s*=>" "$FILE")
echo "✓ Found $func_count function definitions"

# Check for balanced brackets
open_brackets=$(grep -o "\[" "$FILE" | wc -l)
close_brackets=$(grep -o "\]" "$FILE" | wc -l)
if [ "$open_brackets" -ne "$close_brackets" ]; then
    echo "WARNING: Unbalanced square brackets ([ vs ]): $open_brackets vs $close_brackets"
else
    echo "✓ Square brackets balanced: $open_brackets pairs"
fi

open_parens=$(grep -o "(" "$FILE" | wc -l)
close_parens=$(grep -o ")" "$FILE" | wc -l)
if [ "$open_parens" -ne "$close_parens" ]; then
    echo "WARNING: Unbalanced parentheses (() vs )): $open_parens vs $close_parens"
else
    echo "✓ Parentheses balanced: $open_parens pairs"
fi

echo ""
echo "Validation complete! (Note: This is a basic check, not a full Pine Script compiler)"
echo "The file should still be tested in TradingView to verify it compiles correctly."
