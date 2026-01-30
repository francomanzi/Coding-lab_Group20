Hospital Data Monitoring & Archival System - Project Summary
📋 What We Were Asked To Do
Assignment Requirements
Set up a monitoring system with Python simulators that continuously generate log data
Create archive_logs.sh - An interactive script to archive log files with timestamps
Create analyze_logs.sh - A script to analyze logs and generate statistical reports
Implement proper error handling for invalid inputs and missing files
Organize files in a specific directory structure
Submit to GitHub with proper documentation


✅ What We Did
1. System Setup
Created directory structure:
bash
hospital_data/
├── active_logs/              # Where live data is collected
├── archived_logs/            # Where old logs are stored
│   ├── heart_data_archive/
│   ├── temperature_data_archive/
│   └── water_usage_data_archive/
└── reports/                  # Where analysis reports go
Set up simulators:

heart_monitor.py - Generates heart rate data from 2 monitors
temp_sensor.py - Generates temperature data from 2 sensors
water_meter.py - Generates water usage data from 1 meter


2. Archive Script (archive_logs.sh)
Purpose: Move active logs to archive with timestamp, create new empty log for continued monitoring
What it does:

Shows menu with 3 options (Heart Rate, Temperature, Water Usage)
Validates user input (only accepts 1, 2, or 3)
Moves selected log to archive folder with timestamp in filename
Creates new empty log file so monitoring continues

Key Commands & How They Work:

Command
Purpose
Example
date +%Y-%m-%d_%H:%M:%S
Generate timestamp
Output: 2026-01-29_17:45:30
mv file.log archive/file_timestamp.log
Move and rename file
Moves log to archive with new name
touch file.log
Create empty file
Makes new empty log for continued monitoring
[ -f file ]
Check if file exists
Returns true if file exists
[ -s file ]
Check if file has content
Returns true if file is not empty
mkdir -p path/to/dir
Create directories
Creates full path, doesn't error if exists
sed 's/pattern/replacement/'
Text manipulation
Removes _log.log from filename
case $var in ... esac
Menu logic
Tests user input against patterns
read -r variable
Get user input
Reads what user types into variable
Error Handling:

Checks if log file exists before archiving
Warns if log file is empty and asks for confirmation
Creates archive directories if they don't exist
Rejects invalid menu choices


3. Analysis Script (analyze_logs.sh)
Purpose: Count device occurrences and record timestamps, generate statistical report
What it does:

Shows menu to select which log to analyze
Extracts all unique device names from the log
Counts how many times each device appears
Records first and last timestamp for each device
Appends results to cumulative report file

Key Commands & How They Work:

Command
Purpose
Example
awk '{print $3}'
Extract column from text
Gets device name (3rd column)
sort
Sort lines alphabetically
Organizes data for deduplication
uniq
Remove duplicate lines
Gets unique device names (only works on sorted data)
grep "pattern" file
Find matching lines
Finds all lines containing device name
wc -l
Count lines
Counts how many times device appears
head -1
Get first line
Extracts earliest timestamp
tail -1
Get last line
Extracts latest timestamp
>> file
Append to file
Adds to report without overwriting
while read var; do ... done
Loop through input
Processes each device name
The Analysis Pipeline:
bash
# Step 1: Extract device names from column 3
awk '{print $3}' logfile

# Step 2: Sort them alphabetically
| sort

# Step 3: Remove duplicates to get unique devices
| uniq

# Step 4: Process each unique device
| while read device; do
    # Count occurrences
    count=$(grep "$device" logfile | wc -l)
    
    # Get first timestamp
    first=$(grep "$device" logfile | head -1 | awk '{print $1, $2}')
    
    # Get last timestamp  
    last=$(grep "$device" logfile | tail -1 | awk '{print $1, $2}')
done


🔧 Command Combinations Explained
Piping (|) - Sending output to next command
bash
command1 | command2 | command3

Output of command1 becomes input for command2
Output of command2 becomes input for command3
Example: cat file.log | grep "Monitor_A" | wc -l
Read file → filter for Monitor_A → count lines


Command Substitution ($()) - Capture command output
bash
variable=$(command)

Runs the command and stores its output in variable
Example: timestamp=$(date +%Y-%m-%d_%H:%M:%S)
Runs date command and stores result in timestamp


Redirection
bash
>  file    # Overwrite file with output
>> file    # Append output to file

Example: echo "text" >> report.txt adds line to existing file

Conditional Testing ([ ])
bash
[ condition ]    # Test if condition is true
```
- `-f file` : file exists and is regular file
- `-d dir` : directory exists
- `-s file` : file exists and is not empty
- `!` : NOT (negates the test)

---

## 📊 What The Scripts Actually Produce

### **Archive Output:**
```
Selected: Heart Rate
Archiving heart_rate_log.log...
Successfully archived to: 
  hospital_data/archived_logs/heart_data_archive/heart_rate_2026-01-29_17:45:30.log
Created new empty log file: 
  hospital_data/active_logs/heart_rate_log.log
```

**Result:** Old log safely stored, monitoring continues without interruption

---

### **Analysis Output (in report file):**
```
========================================
Heart Rate Analysis - 2026-01-29 18:30:45
========================================
Device: HeartRate_Monitor_A - Count: 1247
  First entry: 2026-01-29 17:30:15
  Last entry: 2026-01-29 18:30:42

Device: HeartRate_Monitor_B - Count: 1247
  First entry: 2026-01-29 17:30:15
  Last entry: 2026-01-29 18:30:42
Result: Statistical summary showing device activity patterns


🎯 Key Skills Demonstrated

Skill Category
What We Used
User Interaction
read, echo, case statements, colored output
File Operations
mv, touch, mkdir -p, file existence checks
Text Processing
awk, grep, sed, sort, uniq
Data Analysis
Pipelines, counting, timestamp extraction
Error Handling
Conditional tests, input validation, user warnings
Automation
Background processes, automatic directory creation
Code Organization
Functions, variables, modular design


📈 How It Works In Practice
Typical Usage Flow:
Start monitoring:

bash
   python3 heart_monitor.py start
   python3 temp_sensor.py start
   python3 water_meter.py start
→ Data accumulates in active_logs/

After some time, archive logs:

bash
   ./archive_logs.sh
   # Select option 1 (Heart Rate)
→ Old log moved to archive with timestamp, new empty log created

Analyze the data:

bash
   ./analyze_logs.sh
   # Select option 1 (Heart Rate)
→ Statistics written to reports/analysis_report.txt

View results:

bash
   cat hospital_data/reports/analysis_report.txt
→ See device counts and timestamps

Stop monitoring when done:

bash
   python3 heart_monitor.py stop
   python3 temp_sensor.py stop
   python3 water_meter.py stop


🎓 Why This Matters
Real-world applications:

Web servers rotate logs daily (Apache, Nginx)
Databases archive old transaction logs
System monitoring tools analyze performance logs
DevOps engineers automate log management

What we learned:

How to process large text files efficiently
How to automate repetitive system administration tasks
How to handle user interaction in scripts
How to extract meaningful insights from raw data
How to maintain systems without manual intervention


 Final Deliverables
 archive_logs.sh - Interactive archival with timestamp naming

 analyze_logs.sh - Statistical analysis with device counting

 README.md - Complete documentation

 Python simulators - Continuous data generation

 Organized directory structure - Proper file management

 Error handling - Robust scripts that handle edge cases

 GitHub repository - Version controlled project


Project Status: Complete and fully functional 

Skills Applied: Shell scripting, log management, data analysis, automation
