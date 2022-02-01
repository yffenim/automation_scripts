#!/bin/bash

TIME=20190505
EXTENSION="epscript.tar"
FILENAME=$TIME$EXTENSION
SOURCE=~/Documents/epscript/
BACKUP=~/Documents

tar -cvpzfW $BACKUP/$FILENAME $SOURCE

# Giving me a read error on syntax for tar?
