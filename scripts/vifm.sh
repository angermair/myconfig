#!/bin/bash

if [ $(wmctrl -l | grep "VIFM" | wc -l) -gt 0 ]; then
    wmctrl -a vifm 
else
    xfce4-terminal -e vifm 
fi
