#!/bin/bash

# Use find to directly list directories containing JPG files
find . -type f -name "*.jpg" -exec dirname {} + | sort -uz | while IFS= read -r d; do
    # Check if the directory exists
    if [ -d "$d" ]; then
        # Get the directory name without leading path
        dir_name=$(basename "$d")
        # Change into the directory
        cd "$d" || continue  # continue to the next iteration if cd fails
        # Convert JPG files to PDF
        convert *.jpg "../${dir_name}.pdf"
        # Return to the original directory
        cd - > /dev/null
    fi
done
