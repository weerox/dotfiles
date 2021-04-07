#!/bin/sh

for i in {0..100..10}; do
	inkscape --export-type=png --export-filename=battery_percentage-$i --export-id=percentage-$i battery.svg.new
	inkscape --export-type=png --export-filename=battery_percentage-$i-charging --export-id=percentage-$i-charging battery.svg.new
done
