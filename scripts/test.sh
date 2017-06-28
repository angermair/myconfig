#!/bin/bash
echo $1
let index=$1-1
# todo validate parameter
desktop=$(wmctrl -d | grep '[0-9]  \*' | cut -d' ' -f1)
windows=($(wmctrl -l | grep "0[xX][0-9a-fA-F]*  $desktop" | cut -d' ' -f1))
wmctrl -i -a ${windows[$index]}
