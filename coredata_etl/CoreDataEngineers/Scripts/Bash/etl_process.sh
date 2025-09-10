#!/bin/bash

# Define environment variable for the URL
export CSV_URL="https://raw.githubusercontent.com/Ayoola-d/Data-Engineering-Projects/main/etl-pipeline/Country-GDP-2023.csv"

# Define directories
RAW_DIR="raw"
TRANSFORMED_DIR="Transformed"
GOLD_DIR="Gold"
LOG_FILE="etl_log.txt"
DOWNLOADED_FILE="Country-GDP-2023.csv"
TRANSFORMED_FILE="2023_year_finance.csv"

# Start logging
echo "--- ETL Process Started at $(date) ---" | tee -a $LOG_FILE

# Step 1: Extract
echo "Starting Extraction step..." | tee -a $LOG_FILE
mkdir -p "$RAW_DIR"
echo "Created directory: $RAW_DIR" | tee -a $LOG_FILE
echo "Downloading CSV file from $CSV_URL..." | tee -a $LOG_FILE
curl -o "$RAW_DIR/$DOWNLOADED_FILE" "$CSV_URL"

# Check if the file was downloaded successfully
if [ -f "$RAW_DIR/$DOWNLOADED_FILE" ]; then
    echo "SUCCESS: File downloaded and saved to $RAW_DIR/$DOWNLOADED_FILE" | tee -a $LOG_FILE
else
    echo "ERROR: Failed to download the file." | tee -a $LOG_FILE
    exit 1
fi

echo "Extraction complete." | tee -a $LOG_FILE

# Step 2: Transform
echo "Starting Transformation step..." | tee -a $LOG_FILE
mkdir -p "$TRANSFORMED_DIR"
echo "Created directory: $TRANSFORMED_DIR" | tee -a $LOG_FILE
sed '1s/Variable_code/variable_code/' "$RAW_DIR/$DOWNLOADED_FILE" | cut -d',' -f1,2,3,4 > "$TRANSFORMED_DIR/$TRANSFORMED_FILE"

# Confirm transformation and saving
if [ -f "$TRANSFORMED_DIR/$TRANSFORMED_FILE" ]; then
    echo "SUCCESS: File transformed and saved to $TRANSFORMED_DIR/$TRANSFORMED_FILE" | tee -a $LOG_FILE
else
    echo "ERROR: Failed to transform or save the file." | tee -a $LOG_FILE
    exit 1
fi

echo "Transformation complete." | tee -a $LOG_FILE

# Step 3: Load
echo "Starting Loading step..." | tee -a $LOG_FILE
mkdir -p "$GOLD_DIR"
echo "Created directory: $GOLD_DIR" | tee -a $LOG_FILE
mv "$TRANSFORMED_DIR/$TRANSFORMED_FILE" "$GOLD_DIR/"

# Confirm loading
if [ -f "$GOLD_DIR/$TRANSFORMED_FILE" ]; then
    echo "SUCCESS: File loaded into the Gold directory." | tee -a $LOG_FILE
else
    echo "ERROR: Failed to load the file into the Gold directory." | tee -a $LOG_FILE
    exit 1
fi

echo "Loading complete." | tee -a $LOG_FILE
echo "--- ETL Process Finished at $(date) ---" | tee -a $LOG_FILE