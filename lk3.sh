#!/bin/bash
# kill_recent_sessions.sh
# This script monitors the current user sessions, sorts them by login time,
# and kills all sessions except the two oldest (i.e. the earliest logged-in sessions).
# It extracts the terminal (TTY) from the "who" output and uses it to kill those sessions.

# Obtain a sorted list of sessions.
# Assumes "who" output fields are: username TTY Month Day Time (and more)
sorted_sessions=$(who | sort -k3M -k4n -k5)

# Count total sessions.
session_count=$(echo "$sorted_sessions" | wc -l)
echo "Total sessions (sorted oldest first): $session_count"

# Do nothing if two or fewer sessions are present.
if [ "$session_count" -le 2 ]; then
    echo "Two or fewer sessions detected. No action required."
    exit 0
fi

# Optionally, determine the current shell's TTY to avoid killing your own session.
current_tty=$(tty | sed 's#/dev/##')
echo "Current session TTY: $current_tty"

# Get TTYs for all sessions except the first two (the oldest).
to_kill=$(echo "$sorted_sessions" | sed '1,2d' | awk '{print $2}')

# Loop over each TTY and kill the session.
for tty in $to_kill; do
    # Skip the current session if it appears in the list.
    if [ "$tty" = "$current_tty" ]; then
        echo "Skipping current session on TTY: $tty"
        continue
    fi
    echo "Killing session on TTY: $tty"
    # Kill all processes associated with the terminal.
    pkill -KILL -t "$tty"
done
