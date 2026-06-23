#!/bin/bash

# A script to convert video files using a standard ffmpeg command.
# This script takes a single input file and outputs a new file with the same name
# but with a ".mp4" extension.

# Check if an input file was provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

input_file="$1"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "Error: Input file '$input_file' not found."
    exit 1
fi

# Get the base name of the input file without its extension
base_name=$(basename -- "$input_file")
extension="${base_name##*.}"
file_name="${base_name%.*}"

# Construct the output filename
#output_file="${file_name}.mp4"
output_file=$(date +%Y%m%d_%H%M%S).mp4

# The ffmpeg command with the specified arguments.
# -i "$input_file"                : Specifies the input file.
# -c:v libx264                   : Specifies the video codec to use (H.264).
# -crf 23                        : Sets the constant rate factor. Lower values mean better quality, higher values mean smaller size. 23 is a good default.
# -profile:v baseline            : Sets the H.264 profile. Baseline is compatible with a wide range of devices.
# -level 3.0                     : Sets the H.264 level. Level 3.0 is widely supported.
# -movflags faststart            : Moves key data to the beginning of the file for faster playback on the web.
# -pix_fmt yuv420p               : Sets the pixel format to ensure compatibility.
# -vf "crop=in_w*0.95:in_h*0.95,scale=trunc(iw/2)*2:trunc(ih/2)*2" : Applies a crop filter to remove 5% from the right and bottom, then ensures the video dimensions are even.
# -an                            : Removes any audio from the output file.
ffmpeg -i "$input_file" -r 15 -c:v libx264 -crf 23 -profile:v baseline -level 3.0 -movflags faststart -pix_fmt yuv420p -vf "crop=in_w*0.9:in_h*0.9,scale=trunc(iw/2)*2:trunc(ih/2)*2" -an "$output_file"

# Check the exit status of the ffmpeg command
if [ $? -eq 0 ]; then
    echo "Conversion successful! Output file is: $output_file"
else
    echo "Conversion failed. Please check the error messages above."
    exit 1
fi

