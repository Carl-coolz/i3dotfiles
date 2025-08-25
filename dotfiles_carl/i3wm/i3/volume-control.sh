#!/bin/bash

# Define step (change amount per key press)
STEP=5%

# Get current default sink
SINK=$(pactl get-default-sink)

# Get current volume
CURRENT_VOL=$(pactl get-sink-volume "$SINK" | grep -oP '\d+%' | head -1 | tr -d '%')

# Decide action
case "$1" in
    up)
        if [ "$CURRENT_VOL" -lt 100 ]; then
            pactl set-sink-volume "$SINK" +$STEP
        fi
        ;;
    down)
        pactl set-sink-volume "$SINK" -$STEP
        ;;
    mute)
        pactl set-sink-mute "$SINK" toggle
        ;;
    *)
        echo "Usage: $0 {up|down|mute}"
        exit 1
        ;;
esac

# Ensure volume never goes above 100%
NEW_VOL=$(pactl get-sink-volume "$SINK" | grep -oP '\d+%' | head -1 | tr -d '%')
if [ "$NEW_VOL" -gt 100 ]; then
    pactl set-sink-volume "$SINK" 100%
fi
