#!/bin/bash

# declare -a user_array=()
# user_array=("one")
# echo "before loop, the array is: $user_array"

# for (( ; ; ))
# do
#	read -p "Please add a name:  " response
#	echo $response
#	echo "the current array is $user_array"
#	if [ $response == "done" ]
#	then
#		echo "Preparing file..."
#		echo "user array is: $user_array"
#		exit 0
#	else
#		echo "inside the add to array condition"
#	  user_array+=( $response )
		#user_array+=($response)
#	fi
# done
echo "Hello! Welcome to spaghetti style program for batch adding new users!"

create_user_objects () {
    file="./user_file.txt"
    user_id=1015
    group_id=1016
    echo $my_array
}


input_loop () {
while read -p "please enter a username or press 'g' to generate user file: "  user
do
    if [ $user = "g" ]
    then
        echo "going to g"
        create_user_objects $my_array
    else
    my_array=("${my_array[@]}" $user)
    echo $my_array
    fi
done
}

input_loop

printf -- 'data%s ' "${my_array[@]}"

