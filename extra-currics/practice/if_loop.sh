#!/bin/bash

# loop syntax using the output of a command as conditional
# to use a variable, do not have brackets
if [ $(whoami) = 'root' ]; then
	echo "You are root"
else
	echo "You are not root"
fi

