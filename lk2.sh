#!/bin/bash
# session_monitor.sh
# This script monitors user sessions and reports changes.
# It compares the output of "who" every 10 seconds and notifies if there's any difference.

# Temporary file to hold previous sessions state.
PREV_SESSIONS="/tmp/prev_sessions.log"

# Capture the initial state of user sessions.
who > "$PREV_SESSIONS"

echo "Monitoring user sessions. Press Ctrl+C to stop."

# Loop indefinitely
while true; do
    # Capture the current state of user sessions in a temporary file.
    CURRENT_SESSIONS=$(mktemp)
    who > "$CURRENT_SESSIONS"

    # Compare the current state with the previous state.
    if ! diff -q "$PREV_SESSIONS" "$CURRENT_SESSIONS" >/dev/null; then
        echo "User session change detected at $(date):"

        # Show the difference:
        diff "$PREV_SESSIONS" "$CURRENT_SESSIONS"
        
        # Optionally, you could send an email or write to a log file here.
        # For example, to send an email (requires mailx configured):
        # mailx -s "User Session Change at $(date)" you@example.com < "$CURRENT_SESSIONS"

        # Update the previous sessions state.
        cp "$CURRENT_SESSIONS" "$PREV_SESSIONS"
    fi

    # Clean up the temporary file.
    rm "$CURRENT_SESSIONS"

    # Wait for 10 seconds before checking again.
    sleep 10
done
