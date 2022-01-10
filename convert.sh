#!/bin/bash
# Batch convert .mp4 files under ./ to .gif files
# new dimensions = .5W*.5H, fps = 15 to save space
# Move original files to original/

IFS=$'\n' # Prevent internal spaces in filenames from being interpreted as separators
vids=($(find -maxdepth 1 -name "*.mp4")) # No recursive
vid_count=${#vids[@]}
if [[ $vid_count -eq 0 ]]; then echo "No files to convert"; exit 1; fi
read -p "You are about to convert $vid_count files. Proceed? [y/n] "
if [[ ! ( $REPLY = y || $REPLY = Y ) ]]; then echo "Aborting"; exit 1; fi
if [[ ! ( -d original/ ) ]]; then mkdir original; fi
for vid in ${vids[@]}; do
	vid_name=$(basename "$vid")
	gif_name="${vid_name%\.mp4}.gif"
	# -y: force overwrite
	# -loglevel warning: quiet/less verbose output
	# -vf scale=iw/2:ih/2: rescale
	# -r 15: 15fps
	ffmpeg -y -loglevel warning -i "$vid_name" -vf scale=iw/2:ih/2 -r 15 "$gif_name"
	if [[ $? -eq 0 ]]; then
		echo "$vid_name -> $gif_name"
		mv "$vid_name" original/
	else
		echo "$vid_name: conversion failed"
	fi
done
unset IFS
echo "Done. Original mp4 files moved to original/"