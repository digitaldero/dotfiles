#!/bin/bash
#CLEAN_TEXT=$(xclip -selection clipboard -o | sed 's/\r$/\n/')

# 1. Get clipboard, strip ALL ^M (CR) characters, and save
# Using 'tr' is faster and more thorough for clearing ^M everywhere
CLEAN_TEXT=$(xclip -selection clipboard -o | tr -d '\r')

# 2. Push it back as UTF-8
echo -n "$CLEAN_TEXT" | xclip -selection clipboard -t UTF8_STRING

# 3. Notify (Optional: you can comment this out if it gets annoying for fast-pasting)
notify-send "Clipboard Cleaned" "Unix & UTF-8 ready" --icon=terminal --expire-time=1500

# 4. Small delay to ensure X11 registers the clipboard change
sleep 0.1

# 5. Paste instantly
xdotool key --clearmodifiers ctrl+v
