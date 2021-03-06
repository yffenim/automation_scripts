#!/bin/bash

# bash script to batch add new linux users

# Instructions
# Loop through array and for each user, 
# generate a random password
# create a UID and GID in incrementing values starting from 1013 and add to the user data structure
# generate a random string as the password and add it to the user data structure
# generate home dir based on userna,e
# everyone has the same shell!

# Questions:
# If the password generated here is visible, does it automatically get encrypted into /usr/shadows when I run the `sudo newusers` command?

# Format for the user data structure
# UserName:Password:UID:GID:comments:HomeDirectory:UserShell


# Initiate an array of usernames to add
user_array=("sam" "joe" "amy" "sara" "admin")

# Initiate a file for new user objects
file="./users_file.txt"

# Initialize UID and GID for new users
user_id=1015
group_id=1016

# Loop through array
for user in "${user_array[@]}"
do

# set default home directory
	home="/home/$user"

# generate random string for password
pw=$(cat /dev/urandom | base64 | tr -dc "a-zA-Z0-9!@#$%^&*()_+?><~\;'" | fold -w 32 | head -n 1)

# generate user data object
	user_obj="$user:$pw:$user_id:$group_id::$home:/bin/sh"

# put user data object into new_user file
	echo $user_obj >> $file

# Why did this not work?!
#	cat <<EOF >./new_users.md
#	$user_obj
#	EOF

# increment UID and GID counts
user_id=$((user_id+=1))
group_id=$((group_id+=1))

	
done



