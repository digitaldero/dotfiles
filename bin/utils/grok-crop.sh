#!/bin/bash

# Check if a file was provided as an argument
if [ -z "$1" ]; then
  echo "Error: No input file specified."
  echo "Usage: $0 <input_video.mp4>"
  exit 1
fi

INPUT="$1"
# Create the output filename by appending "_crop.mp4" to the original filename (minus extension)
OUTPUT="${INPUT%.*}_crop.mp4"

echo "Processing: $INPUT"
echo "Output will be saved as: $OUTPUT"

# Run FFmpeg to crop and strip all metadata
ffmpeg -i "$INPUT" \
  -vf "crop=iw*0.93:ih*0.93:iw*0.1:0" \
  -c:a copy \
  -map_metadata -1 \
  -map_chapters -1 \
  -fflags +bitexact \
  "$OUTPUT"

echo "Done! Cleaned and cropped video saved to $OUTPUT"
