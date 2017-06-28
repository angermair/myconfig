#!/bin/bash

if [ $(wmctrl -l | grep -i "xfce4-terminal" | wc -l) -gt 0 ]; then
   wmctrl -a xfce4-terminal 
else
   exec xfce4-terminal --title="xfce4-terminal" 
fi
