#!/bin/bash
# BurstXBundle
#
# Created by Andrew Scott on 2/10/18.

cd ~/Library/Application\ Support/BurstXBundle/
# Applescript is utter shit
osascript -e 'set short_name to do shell script "whoami"' \
          -e 'set p to "/Users/" & short_name & "/Library/Application Support/BurstXBundle/tmp_plot_command.sh"' \
          -e 'set filePath to POSIX file p' \
          -e 'set contentsOfFile to (read file filePath)' \
          -e 'do shell script contentsOfFile with administrator privileges'

