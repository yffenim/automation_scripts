#!/bin/bash

#script to check which users have a home directory and then which of those users have sudo

# check for users with home dir
users=$(cut -d : -f 1,6 /etc/passwd | grep home | cut -d ":" -f 1)
echo $users

# add to array
declare -a users=$(cut -d : -f 1,6 /etc/passwd | grep home | cut -d ":" -f 1)
echo ${users[@]}
