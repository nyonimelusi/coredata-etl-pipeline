#!/bin/bash

DB_NAME="posey"
DB_USER="postgres"
OUTPUT_FILE="../../data/extracted_data.csv"

echo "--- Data Extraction Started at $(date) ---"

# Use psql's \copy command to export the data to a CSV file
psql -U "$DB_USER" -d "$DB_NAME" -h localhost -c "\copy accounts_and_web_events TO '$OUTPUT_FILE' DELIMITER ',' CSV HEADER;" 2>&1

echo "--- Data Extraction Finished at $(date) ---"