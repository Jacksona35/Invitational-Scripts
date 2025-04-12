#!/bin/bash
# kill_sessions_continuous.sh
# This script continuously monitors user sessions and kills all sessions except the two oldest.
# It sorts sessions by login time, leaving the two oldest, and kills additional sessions by terminal (TTY).

# Run this script as root.

while true; do
    # Capture current sessions from "who" and sort them based on login time.
    # Sorting is done by the Month, Day, and Time fields.
    sorted_sessions=$(who | sort -k3M -k4n -k5)
    
    # Count the total number of sessions.
    session_count=$(echo "$sorted_sessions" | wc -l)
    echo "$(date): Total sessions (sorted oldest first): $session_count"
    
    # Only proceed if there are more than two sessions.
    if [ "$session_count" -gt 2 ]; then
        # Get the TTY of the current session (avoid disconnecting yourself).
        current_tty=$(tty | sed 's#/dev/##')
        echo "Current session TTY: $current_tty"
        
        # Extract TTY field for all sessions except the first two (the oldest sessions).
        # Assumes 'who' output's 2nd column is the TTY.
        extra_sessions=$(echo "$sorted_sessions" | sed '1,2d' | awk '{print $2}')
        
        # Loop through each additional session and kill it.
        for tty in $extra_sessions; do
            # Skip current session.
            if [ "$tty" = "$current_tty" ]; then
                echo "Skipping current session on TTY: $tty"
                continue
            fi
            echo "Killing session on TTY: $tty"
            pkill -KILL -t "$tty"
        done
    fi
    
    # Pause for 10 seconds before checking again.
    sleep 10
done
