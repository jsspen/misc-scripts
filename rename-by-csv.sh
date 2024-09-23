#!/bin/bash

# Input CSV file
csv_file="rename_list.csv"

# Process each line of the CSV file
while IFS=, read -r old_name new_name; do
    # Find the file that matches the old name (ignoring extension)
    file_to_rename=$(find . -maxdepth 1 -type f -name "${old_name}.*" -print -quit)
    
    if [ -n "$file_to_rename" ]; then
        # Extract the file extension from the found file
        extension="${file_to_rename##*.}"
        
        # Construct the new file name with the preserved extension
        new_file_name="${new_name}.${extension}"
        
        # Rename the file
        mv "$file_to_rename" "$new_file_name"
        echo "Renamed $file_to_rename to $new_file_name"
    else
        echo "File matching $old_name not found."
    fi
done < "$csv_file"
