#!/bin/bash

# Initialize an empty array
declare -a user_array=()

while ??
# prompt for new user name and save in user variable
read -p "Please enter a username or 'q' to quit: " user

# add user name to array
user_array+=($user)
echo $user_array


