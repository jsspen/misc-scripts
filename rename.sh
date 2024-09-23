#!/bin/bash

# Loop through each subdirectory in the current directory
for dir in */; do
    # Get the current directory name
    current_name=$(basename "$dir")
    
    # Extract title and year from the current directory name
    title=$(echo "$current_name" | cut -d '(' -f 1 | sed 's/ *$//')
    year=$(echo "$current_name" | cut -d '(' -f 2 | cut -d ')' -f 1)
    
    # Rename the directory
    new_name="$year - $title"
    mv "$dir" "$new_name"
    
    echo "Renamed $current_name to $new_name"
done
