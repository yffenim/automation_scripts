#!/bin/bash

echo "Hello! Welcome to a spaghetti style program for adding new users!"

# generate a random alphanumeric string of 32 chars in length.
create_password () {
    pw=$(cat /dev/urandom | base64 | tr -dc "a-zA-Z0-9!@#$%^&*()_+?><~\;'" | fold -w 32 | head -n 1)
    echo $pw
}

# create file of new user objects
create_user_objects () {
    file="./new_users.txt"
    user_id=1015
    group_id=1016
    pw=$(create_password)

    for user in "${my_array[@]}"
    do 
        home="/home/$user"
        user_obj="$user:$pw:$user_id:$group_id::$home:/bin/sh"
        echo $user_obj >> $file
        
        user_id=$((user_id+=1))
        group_id=$((group_id+=1))
    done
    exit 0
    }

# process input of new usernames
input_loop () {
while read -p "Please enter a username or 'gen!' to generate users file > "  user
do
    if [ $user = "gen!" ]
    then
        echo "Creating user objects for: ${my_array[@]}"
        echo "File created!"
        echo "hint: run newusers <new_users.txt> to add to system"
        create_user_objects ${my_array[@]} 
    else
    my_array=("${my_array[@]}" $user)
    fi
done
}

input_loop


