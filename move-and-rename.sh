#!/bin/bash

## Rename files to match the name of the folder that they're stored in
## then move the files out of those subfolders
## For cases where there are 120 files, each in their own folder
## and the file should have the folder's name
## and they don't all need to be in their own folder

# Get the root directory (where the script is located)
ROOT_DIR="$(dirname "$0")"

# Iterate over each subdirectory in the root directory
for SUBDIR in "$ROOT_DIR"/*/; do
    # Get the name of the subdirectory (without the trailing slash)
    SUBDIR_NAME=$(basename "$SUBDIR")

    # Initialize a counter for numbering files
    COUNT=1

    # Iterate over each file in the subdirectory
    for FILE in "$SUBDIR"*; do
        if [ -f "$FILE" ]; then
            # Get the file extension
            EXT="${FILE##*.}"
            # Create the new file name
            NEW_NAME="${SUBDIR_NAME}"
            # If there is more than one file, append the count
            if [ "$(ls -1q "$SUBDIR" | wc -l)" -gt 1 ]; then
                NEW_NAME="${NEW_NAME} ($COUNT)"
            fi
            NEW_NAME="${NEW_NAME}.${EXT}"

            # Move and rename the file to the root directory
            mv "$FILE" "$ROOT_DIR/$NEW_NAME"
            # Increment the counter
            ((COUNT++))
        fi
    done
done

echo "All files have been renamed and moved to the root directory."
