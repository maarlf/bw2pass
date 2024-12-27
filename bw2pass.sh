#!/bin/bash

# Check if the Bitwarden export file argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 path/to/bitwarden_export.json"
    exit 1
fi

# Path to your Bitwarden export file from the argument
BITWARDEN_FILE="$1"

# Directory where you want to store Pass entries
PASS_DIR="$HOME/.password-store"

# Function to check JSON structure
check_json_structure() {
    if ! jq -e '.items' "$BITWARDEN_FILE" > /dev/null; then
        echo "Error: The JSON structure is not valid or does not contain 'items'."
        exit 1
    fi
}

# Function to import Bitwarden data
import_bitwarden() {
    jq -c '.items[]' "$BITWARDEN_FILE" | while read -r entry; do
        name=$(echo "$entry" | jq -r '.name')
        username=$(echo "$entry" | jq -r '.login.username')
        password=$(echo "$entry" | jq -r '.login.password')

        # Check if name, username, and password are not null
        if [ -z "$name" ] || [ -z "$username" ] || [ -z "$password" ]; then
            echo "Warning: Skipping an entry due to missing fields."
            continue
        fi

        # Create a Pass entry with the username as a sub-entry
        echo "$password" | pass insert -m "$name/$username"
    done
}

# Check if the Bitwarden file exists and is readable
if [ ! -f "$BITWARDEN_FILE" ]; then
    echo "Error: The specified Bitwarden export file does not exist or is not a file."
    exit 1
fi

# Check JSON structure
check_json_structure

# Import Bitwarden data
import_bitwarden

echo "Import completed successfully."

