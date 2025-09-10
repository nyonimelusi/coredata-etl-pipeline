#!/bin/bash

DB_NAME="posey"
DB_USER="<postgres>"
SQL_SCRIPT_PATH="../SQL/transform.sql"
LOG_FILE="transform_log.txt"

echo "--- SQL Transformation Started at $(date) ---" | tee -a $LOG_FILE

# Run the SQL script using psql
psql -U "$DB_USER" -d "$DB_NAME" -f "$SQL_SCRIPT_PATH" 2>&1 | tee -a $LOG_FILE

echo "--- SQL Transformation Finished at $(date) ---" | tee -a $LOG_FILE