#!/bin/bash

# analyze_logs.sh - Intelligent log analysis script for hospital monitoring system

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Define directories
ACTIVE_LOGS_DIR="hospital_data/active_logs"
REPORTS_DIR="hospital_data/reports"
REPORT_FILE="${REPORTS_DIR}/analysis_report.txt"

# Function to display menu
display_menu() {
    echo "=================================="
    echo "  Log Analysis System"
    echo "=================================="
    echo "Select log file to analyze:"
    echo "1) Heart Rate (heart_rate_log.log)"
    echo "2) Temperature (temperature_log.log)"
    echo "3) Water Usage (water_usage_log.log)"
    echo "=================================="
}

# Function to check if reports directory exists
check_reports_dir() {
    if [ ! -d "$REPORTS_DIR" ]; then
        mkdir -p "$REPORTS_DIR"
        echo -e "${GREEN}Created reports directory: ${REPORTS_DIR}${NC}"
    fi
}

# Function to analyze heart rate log
analyze_heart_rate() {
    local log_file="${ACTIVE_LOGS_DIR}/heart_rate_log.log"
    
    if [ ! -f "$log_file" ]; then
        echo -e "${RED}Error: Log file '$log_file' not found!${NC}"
        return 1
    fi
    
    if [ ! -s "$log_file" ]; then
        echo -e "${YELLOW}Warning: Log file is empty!${NC}"
        return 1
    fi
    
    echo -e "${BLUE}Analyzing Heart Rate log...${NC}"
    
    # Write header to report
    echo "" >> "$REPORT_FILE"
    echo "========================================" >> "$REPORT_FILE"
    echo "Heart Rate Analysis - $(date '+%Y-%m-%d %H:%M:%S')" >> "$REPORT_FILE"
    echo "========================================" >> "$REPORT_FILE"
    
    # Count device occurrences and get timestamps
    # Log format: YYYY-MM-DD HH:MM:SS DeviceName Value
    awk '{print $3}' "$log_file" | sort | uniq | while read -r device; do
        count=$(grep "$device" "$log_file" | wc -l)
        echo "Device: $device - Count: $count" >> "$REPORT_FILE"
        
        # Get first timestamp for this device
        first_timestamp=$(grep "$device" "$log_file" | head -1 | awk '{print $1, $2}')
        echo "  First entry: $first_timestamp" >> "$REPORT_FILE"
        
        # Get last timestamp for this device
        last_timestamp=$(grep "$device" "$log_file" | tail -1 | awk '{print $1, $2}')
        echo "  Last entry: $last_timestamp" >> "$REPORT_FILE"
        echo "" >> "$REPORT_FILE"
    done
    
    echo -e "${GREEN}Analysis complete! Results appended to ${REPORT_FILE}${NC}"
}

# Function to analyze temperature log
analyze_temperature() {
    local log_file="${ACTIVE_LOGS_DIR}/temperature_log.log"
    
    if [ ! -f "$log_file" ]; then
        echo -e "${RED}Error: Log file '$log_file' not found!${NC}"
        return 1
    fi
    
    if [ ! -s "$log_file" ]; then
        echo -e "${YELLOW}Warning: Log file is empty!${NC}"
        return 1
    fi
    
    echo -e "${BLUE}Analyzing Temperature log...${NC}"
    
    echo "" >> "$REPORT_FILE"
    echo "========================================" >> "$REPORT_FILE"
    echo "Temperature Analysis - $(date '+%Y-%m-%d %H:%M:%S')" >> "$REPORT_FILE"
    echo "========================================" >> "$REPORT_FILE"
    
    # Count device occurrences
    awk '{print $3}' "$log_file" | sort | uniq | while read -r device; do
        count=$(grep "$device" "$log_file" | wc -l)
        echo "Device: $device - Count: $count" >> "$REPORT_FILE"
        
        # Get first timestamp
        first_timestamp=$(grep "$device" "$log_file" | head -1 | awk '{print $1, $2}')
        echo "  First entry: $first_timestamp" >> "$REPORT_FILE"
        
        # Get last timestamp
        last_timestamp=$(grep "$device" "$log_file" | tail -1 | awk '{print $1, $2}')
        echo "  Last entry: $last_timestamp" >> "$REPORT_FILE"
        echo "" >> "$REPORT_FILE"
    done
    
    echo -e "${GREEN}Analysis complete! Results appended to ${REPORT_FILE}${NC}"
}

# Function to analyze water usage log
analyze_water_usage() {
    local log_file="${ACTIVE_LOGS_DIR}/water_usage_log.log"
    
    if [ ! -f "$log_file" ]; then
        echo -e "${RED}Error: Log file '$log_file' not found!${NC}"
        return 1
    fi
    
    if [ ! -s "$log_file" ]; then
        echo -e "${YELLOW}Warning: Log file is empty!${NC}"
        return 1
    fi
    
    echo -e "${BLUE}Analyzing Water Usage log...${NC}"
    
    echo "" >> "$REPORT_FILE"
    echo "========================================" >> "$REPORT_FILE"
    echo "Water Usage Analysis - $(date '+%Y-%m-%d %H:%M:%S')" >> "$REPORT_FILE"
    echo "========================================" >> "$REPORT_FILE"
    
    # Count device occurrences
    awk '{print $3}' "$log_file" | sort | uniq | while read -r device; do
        count=$(grep "$device" "$log_file" | wc -l)
        echo "Device: $device - Count: $count" >> "$REPORT_FILE"
        
        # Get first timestamp
        first_timestamp=$(grep "$device" "$log_file" | head -1 | awk '{print $1, $2}')
        echo "  First entry: $first_timestamp" >> "$REPORT_FILE"
        
        # Get last timestamp
        last_timestamp=$(grep "$device" "$log_file" | tail -1 | awk '{print $1, $2}')
        echo "  Last entry: $last_timestamp" >> "$REPORT_FILE"
        echo "" >> "$REPORT_FILE"
    done
    
    echo -e "${GREEN}Analysis complete! Results appended to ${REPORT_FILE}${NC}"
}

# Main script execution
main() {
    # Check and create reports directory
    check_reports_dir
    
    # Display menu
    display_menu
    
    # Read user input
    echo -n "Enter choice (1-3): "
    read -r choice
    
    # Process user choice
    case $choice in
        1)
            analyze_heart_rate
            ;;
        2)
            analyze_temperature
            ;;
        3)
            analyze_water_usage
            ;;
        *)
            echo -e "${RED}Error: Invalid choice! Please enter 1, 2, or 3.${NC}"
            exit 1
            ;;
    esac
}

# Run main function
main
