#!/bin/bash

if [ $(wmctrl -l | grep -i "Google chrome" | wc -l) -gt 0 ]; then
   wmctrl -a "Google Chrome" 
else
   exec google-chrome 
fi
