#!/bin/sh

ID=(signal-1 signal-2 signal-3 signal-4 no-connection)

for i in ${ID[@]}; do
	inkscape --export-type=png --export-id=$i wifi.svg
done
