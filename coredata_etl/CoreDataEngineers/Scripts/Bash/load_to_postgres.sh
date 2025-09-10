#!/bin/bash

# --- Configuration ---
DB_NAME="posey"
DB_USER="<nyonimelusi>"
DATA_DIR="/c/Users/DELL/coredata_etl/CoreDataEngineers/posey_data"
LOG_FILE="load_log.txt"

# --- Main Script ---
echo "--- PostgreSQL Data Load Started at $(date) ---" | tee -a $LOG_FILE

# Drop and recreate the database to ensure a clean slate
echo "Dropping and recreating database '$DB_NAME'..." | tee -a $LOG_FILE
psql -U "$DB_USER" -c "DROP DATABASE IF EXISTS $DB_NAME;" 2>&1 | tee -a $LOG_FILE
psql -U "$DB_USER" -c "CREATE DATABASE $DB_NAME;" 2>&1 | tee -a $LOG_FILE

# Check for successful database creation
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to create database. Please check your PostgreSQL setup and username." | tee -a $LOG_FILE
    exit 1
fi

# Create tables
echo "Creating tables..." | tee -a $LOG_FILE
psql -U "$DB_USER" -d "$DB_NAME" -c "
  CREATE TABLE accounts (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    website VARCHAR(255),
    lat DOUBLE PRECISION,
    long DOUBLE PRECISION,
    primary_poc VARCHAR(255),
    sales_rep_id INT
  );
  CREATE TABLE web_events (
    id INT PRIMARY KEY,
    occurred_at TIMESTAMP,
    account_id INT,
    channel VARCHAR(255)
  );
" 2>&1 | tee -a $LOG_FILE

# Load data from CSV files
echo "Loading data from CSV files..." | tee -a $LOG_FILE

psql -U "$DB_USER" -d "$DB_NAME" -c "
  COPY accounts(id, name, website, lat, long, primary_poc, sales_rep_id)
  FROM '$DATA_DIR/accounts.csv'
  DELIMITER ','
  CSV HEADER;
" 2>&1 | tee -a $LOG_FILE

psql -U "$DB_USER" -d "$DB_NAME" -c "
  COPY web_events(id, occurred_at, account_id, channel)
  FROM '$DATA_DIR/web_events.csv'
  DELIMITER ','
  CSV HEADER;
" 2>&1 | tee -a $LOG_FILE

echo "--- PostgreSQL Data Load Finished at $(date) ---" | tee -a $LOG_FILE