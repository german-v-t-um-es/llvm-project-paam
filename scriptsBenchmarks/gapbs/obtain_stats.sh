#!/bin/bash

# Directory containing your .ll files (adjust if needed)
SEARCH_DIR="."

# Path to opt binary
OPT_PATH="../../paamBuild/bin/opt"

# Loop through all .ll files found
find "$SEARCH_DIR" -name "*.ll" | while read -r ll_file; do
    echo "Processing $ll_file..."
    $OPT_PATH -passes="paampass" "$ll_file"

    if [ $? -eq 0 ]; then
        echo "Success: $ll_file"
    else
        echo "Failed: $ll_file"
    fi
    echo "-------------------------"
done
