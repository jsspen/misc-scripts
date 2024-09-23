#!/bin/bash

# Find all .mkv files in the current directory
for file in *.mkv; do
    # Check if the file is a regular file
    if [ -f "$file" ]; then
        # Extract the filename without extension
        filename=$(basename -- "$file" .mkv)
        
        # Create a directory with the same name as the .mkv file
        mkdir -p "$filename"
        
        # Move the .mkv file into the newly created directory
        mv "$file" "$filename/"
        
        echo "Moved $file to $filename/"
    fi
done
