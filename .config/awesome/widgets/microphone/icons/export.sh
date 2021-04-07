#!/bin/sh

ID=(volume-1 volume-1-off volume-2 volume-2-off volume-3 volume-3-off)

for i in ${ID[@]}; do
	inkscape --export-type=png --export-filename=microphone_$i --export-id=$i microphone.svg.new
done
