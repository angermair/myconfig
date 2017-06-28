#!/bin/bash
apps_cmd=('xfce4-terminal' 'google-chrome')
apps_alias=('terminal' 'chrome')

if [ $(wmctrl -l | grep -i $1 | wc -l) -gt 0 ]; then
   wmctrl -a $1
else
   exec $1 
fi

