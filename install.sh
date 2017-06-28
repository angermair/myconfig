#!/bin/bash

# install powerline font
git clone https://github.com/powerline/fonts.git
cd fonts
./install.sh
cd ..
rm -rf fonts

# todo copy files

cp scripts /usr/bin