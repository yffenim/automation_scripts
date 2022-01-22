#!/bin/bash



echo "Hello! Welcome to spaghetti style program for batch adding new users!"

create_user_objects () {
    file="./user_file.txt"
    user_id=1015
    group_id=1016
    echo "'index zero element: '${my_array[0]}'"
    echo "index one element: '${my_array[1]}'"

    for user in "${my_array[@]}"
    do 
        home="/home/$user"
        pw=$(cat /dev/urandom | base64 | tr -dc "a-zA-Z0-9!@#$%^&*()_+?><~\;'" | fold -w 32 | head -n 1)
        user_obj="$user:$pw:$user_id:$group_id::$home:/bin/sh"
        echo $user_obj >> $file
        
        user_id=$((user_id+=1))
        group_id=$((group_id+=1))
    done
    }


input_loop () {
while read -p "please enter a username or press 'g' to generate user file: "  user
do
    if [ $user = "g" ]
    then
        # use echo to capture array return before sending to method. 
        echo "Creating user objects for: ${my_array[@]}"
        create_user_objects ${my_array[@]} 
    else
    my_array=("${my_array[@]}" $user)
    # use echo instead of return which works like exit in bash
    # echo ${my_array[@]}
    fi
done
}

input_loop
echo "outside"
# printf -- 'data%s ' "${my_array[@]}"

