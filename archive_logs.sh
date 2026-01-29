#!/bin/bash

# archive_logs.sh - Interactive log archival script for hospital monitoring system

# Color codes for better user experience
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Define base directories
ACTIVE_LOGS_DIR="hospital_data/active_logs"
ARCHIVED_LOGS_DIR="hospital_data/archived_logs"
HEART_ARCHIVE_DIR="${ARCHIVED_LOGS_DIR}/heart_data_archive"
TEMP_ARCHIVE_DIR="${ARCHIVED_LOGS_DIR}/temperature_data_archive"
WATER_ARCHIVE_DIR="${ARCHIVED_LOGS_DIR}/water_usage_data_archive"

# Function to display menu
display_menu() {
    echo "=================================="
    echo "  Log Archival System"
    echo "=================================="
    echo "Select log to archive:"
    echo "1) Heart Rate"
    echo "2) Temperature"
    echo "3) Water Usage"
    echo "=================================="
}

# Function to create archive directories if they don't exist
check_directories() {
    # Create main archived_logs directory first
    if [ ! -d "$ARCHIVED_LOGS_DIR" ]; then
        mkdir -p "$ARCHIVED_LOGS_DIR"
        echo -e "${GREEN}Created directory: ${ARCHIVED_LOGS_DIR}${NC}"
    fi
    
    # Create subdirectories
    if [ ! -d "$HEART_ARCHIVE_DIR" ]; then
        mkdir -p "$HEART_ARCHIVE_DIR"
        echo -e "${GREEN}Created directory: ${HEART_ARCHIVE_DIR}${NC}"
    fi
    if [ ! -d "$TEMP_ARCHIVE_DIR" ]; then
        mkdir -p "$TEMP_ARCHIVE_DIR"
        echo -e "${GREEN}Created directory: ${TEMP_ARCHIVE_DIR}${NC}"
    fi
    if [ ! -d "$WATER_ARCHIVE_DIR" ]; then
        mkdir -p "$WATER_ARCHIVE_DIR"
        echo -e "${GREEN}Created directory: ${WATER_ARCHIVE_DIR}${NC}"
    fi
}

# Function to archive log file
archive_log() {
    local log_name=$1
    local archive_dir=$2
    local log_type=$3
    
    local log_file="${ACTIVE_LOGS_DIR}/${log_name}"
    
    # Check if log file exists
    if [ ! -f "$log_file" ]; then
        echo -e "${RED}Error: Log file '$log_file' not found!${NC}"
        return 1
    fi
    
    # Check if log file is empty
    if [ ! -s "$log_file" ]; then
        echo -e "${YELLOW}Warning: Log file is empty. Archive anyway? (y/n)${NC}"
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            echo "Archive cancelled."
            return 1
        fi
    fi
    
    # Generate timestamp
    timestamp=$(date +%Y-%m-%d_%H:%M:%S)
    
    # Create archive filename
    # Remove _log.log suffix and add timestamp
    base_name=$(echo "$log_name" | sed 's/_log\.log$//')
    archive_filename="${base_name}_${timestamp}.log"
    archive_path="${archive_dir}/${archive_filename}"
    
    # Archive the log file
    echo -e "${YELLOW}Archiving ${log_name}...${NC}"
    
    if mv "$log_file" "$archive_path"; then
        echo -e "${GREEN}Successfully archived to ${archive_path}${NC}"
        
        # Create new empty log file for continued monitoring
        touch "$log_file"
        echo -e "${GREEN}Created new empty log file: ${log_file}${NC}"
        return 0
    else
        echo -e "${RED}Error: Failed to archive log file!${NC}"
        return 1
    fi
}

# Main script execution
main() {
    # Check and create directories
    check_directories
    
    # Display menu
    display_menu
    
    # Read user input
    echo -n "Enter choice (1-3): "
    read -r choice
    
    # Process user choice
    case $choice in
        1)
            archive_log "heart_rate_log.log" "$HEART_ARCHIVE_DIR" "Heart Rate"
            ;;
        2)
            archive_log "temperature_log.log" "$TEMP_ARCHIVE_DIR" "Temperature"
            ;;
        3)
            archive_log "water_usage_log.log" "$WATER_ARCHIVE_DIR" "Water Usage"
            ;;
        *)
            echo -e "${RED}Error: Invalid choice! Please enter 1, 2, or 3.${NC}"
            exit 1
            ;;
    esac
}

# Run main function
main
