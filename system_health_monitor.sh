#!/bin/bash

# Define thresholds
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

# Define the log file
LOG_FILE="$HOME/system_health_monitor.log"

# Function to log messages
log_message() {
  local MESSAGE=$1
  echo "$(date): $MESSAGE" | tee -a $LOG_FILE
}

# Function to check CPU usage
check_cpu() {
  CPU_USA GE=$(ps -A -o %cpu | awk '{s+=$1} END {print s}')
  if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
    log_message "CPU usage is ${CPU_USAGE}% which is higher than threshold (${CPU_THRESHOLD}%)"
  fi
}

# Function to check memory usage
check_memory() {
  MEMORY_USAGE=$(vm_stat | grep "Pages active" | awk '{print $3}' | sed 's/\.//') # macOS specific command
  TOTAL_MEMORY=$(sysctl hw.memsize | awk '{print $2}') # macOS specific command
  MEMORY_USAGE_PERCENT=$(echo "scale=2; $MEMORY_USAGE * 4096 / $TOTAL_MEMORY * 100" | bc)
  if (( $(echo "$MEMORY_USAGE_PERCENT > $MEMORY_THRESHOLD" | bc -l) )); then
    log_message "Memory usage is ${MEMORY_USAGE_PERCENT}% which is higher than threshold (${MEMORY_THRESHOLD}%)"
  fi
}

# Function to check disk space usage
check_disk() {
  DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//g')
  if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    log_message "Disk space usage is ${DISK_USAGE}% which is higher than threshold (${DISK_THRESHOLD}%)"
  fi
}

# Function to check running processes
check_processes() {
  HIGH_CPU_PROCESSES=$(ps -A -o pid,comm,%cpu --sort=-%cpu | head -n 10)
  HIGH_MEM_PROCESSES=$(ps -A -o pid,comm,%mem --sort=-%mem | head -n 10)
  
  if [ -n "$HIGH_CPU_PROCESSES" ]; then
    log_message "Top CPU consuming processes:\n$HIGH_CPU_PROCESSES"
  fi

  if [ -n "$HIGH_MEM_PROCESSES" ]; then
    log_message "Top memory consuming processes:\n$HIGH_MEM_PROCESSES"
  fi
}

# Create or clear the log file
> $LOG_FILE

# Run checks
check_cpu
check_memory
check_disk
check_processes
