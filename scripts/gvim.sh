#!/bin/bash

if [ $(wmctrl -l | grep -i gvim | wc -l) -gt 0 ]; then
   wmctrl -a gvim
else
   exec gvim 
fi

