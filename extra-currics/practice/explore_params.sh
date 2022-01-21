#!/bin/bash

#RANDOM="STR" tr -dc A-Za-z0-9 </dev/urandom | head -c 50

RANDOM_STRING=$(cat /dev/urandom | base64 | tr -dc "a-zA-Z0-9!@#$%^&*()_+?><~\`;'" | fold -w 32 | head -n 1)

echo $RANDOM_STRING


