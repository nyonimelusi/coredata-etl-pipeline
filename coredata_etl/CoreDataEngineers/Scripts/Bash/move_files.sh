#!/bin/bash

# Define source and destination directories
SOURCE_DIR="/c/Users/DELL/coredata_etl/CoreDataEngineers/source_data"
DEST_DIR="../json_and_CSV"

# Create the destination directory if it doesn't exist
mkdir -p "$DEST_DIR"
echo "Created directory: $DEST_DIR"

# Check if the source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory '$SOURCE_DIR' does not exist."
    exit 1
fi

echo "Moving .csv and .json files from '$SOURCE_DIR' to '$DEST_DIR'..."

# Find and move all .csv and .json files.
find "$SOURCE_DIR" -type f \( -name "*.csv" -o -name "*.json" \) -exec mv -t "$DEST_DIR" {} +

# Confirmation
if [ $? -eq 0 ]; then
    echo "Successfully moved files."
else
    echo "An error occurred during the move operation."
fi