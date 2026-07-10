#!/bin/bash

# ============================================
# SELF-HEALING SCRIPT - heal.sh
# ============================================
# This script monitors the Docker container
# named "simplewebsite" and automatically restarts
# it if it stops running.
#
# How it works:
#   1. Checks if the container is running
#   2. If running   → logs a healthy message
#   3. If stopped   → tries to restart it
#   4. If deleted   → creates a new container
#   5. Waits 10 seconds and repeats forever
#
# Usage:
#   chmod +x heal.sh
#   bash heal.sh
#
# To stop the script:
#   Press Ctrl + C
# ============================================

# ---- CONFIGURATION ----
# Name of the Docker container to monitor
CONTAINER_NAME="simplewebsite"

# Name of the Docker image to use when creating
# a new container (must match what Jenkins builds)
IMAGE_NAME="simplewebsite"

# How often to check the container (in seconds)
CHECK_INTERVAL=10

# ---- HELPER FUNCTION: LOG ----
# This function prints a message with the current
# date and time. It makes our logs easy to read.
#
# Usage: log "INFO" "Your message here"
#
# Output: 2026-07-10 10:30:15 [INFO] Your message here
log() {
    # $1 = log level (INFO, WARNING, SUCCESS, ERROR)
    # $2 = the message to print
    local level="$1"
    local message="$2"

    # Get the current date and time in YYYY-MM-DD HH:MM:SS format
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    # Print the formatted log line
    echo "${timestamp} [${level}] ${message}"
}

# ---- HELPER FUNCTION: IS CONTAINER RUNNING? ----
# Checks if the container is currently running.
# Returns 0 (true) if running, 1 (false) if not.
is_running() {
    # "docker inspect" checks the container's state.
    # --format extracts just the "Running" field.
    # 2>/dev/null hides error messages if the
    # container doesn't exist at all.
    local status
    status=$(docker container inspect --format='{{.State.Running}}' "$CONTAINER_NAME" 2>/dev/null)
    if [ "$status" = "true" ]; then      
        return 0                           
    else                                     
        return 1 
    fi   
}

# ---- HELPER FUNCTION: DOES CONTAINER EXIST? ----
# Checks if the container exists (running or stopped).
# Returns 0 (true) if it exists, 1 (false) if not.
container_exists() {
    # Try to inspect the container.
    # If the command succeeds, the container exists.
    # If it fails, the container does not exist.
    docker container inspect "$CONTAINER_NAME" >/dev/null 2>&1
}
# ---- HELPER FUNCTION: RESTART CONTAINER ----
# Attempts to restart the container.
# If the container was deleted, creates a new one.
restart_container() {
    # First, check if the container still exists
  if container_exists; then
        log "WARNING" "Attempting to restart container..."

        if docker start "$CONTAINER_NAME" >/dev/null 2>&1; then
            log "SUCCESS" "Container restarted successfully."
        else
            log "ERROR" "Failed to restart container."
        fi

    else
        log "WARNING" "Container does not exist. Creating new container..."

        if docker run -d -p 80:80 --name "$CONTAINER_NAME" "$IMAGE_NAME" >/dev/null 2>&1; then
            log "SUCCESS" "New container created successfully."
        else
            log "ERROR" "Failed to create new container."
        fi
    fi
}

# ============================================
# MAIN LOOP
# ============================================
# This loop runs forever, checking the container
# every CHECK_INTERVAL seconds.
#
# Press Ctrl+C to stop the script.
# ============================================

log "INFO" "============================================"
log "INFO" "Self-Healing Monitor Started"
log "INFO" "Container: ${CONTAINER_NAME}"
log "INFO" "Check Interval: ${CHECK_INTERVAL}s"
log "INFO" "============================================"

# Start the infinite monitoring loop
while true; do

    # Log that we are performing a check
    log "INFO" "Checking container..."

    # Check if the container is running
    if is_running; then
        # Container is healthy — nothing to do
        log "INFO" "Container is healthy."
    else
        # Container is NOT running — needs healing
        log "WARNING" "Container stopped."

        # Try to recover the container
        restart_container
    fi

    # Wait before checking again
    sleep "$CHECK_INTERVAL"

done
