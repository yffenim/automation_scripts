#!/bin/bash

declare -a user_array=()
user_array=("one")
echo "before loop, the array is: $user_array"

for (( ; ; ))
do
	read -p "Please add a name:  " response
	echo $response
	echo "the current array is $user_array"
	if [ $response == "done" ]
	then
		echo "Preparing file..."
		echo "user array is: $user_array"
		exit 0
	else
		echo "inside the add to array condition"
	  #WHY IS THIS ARRAY ITEM NOT GETTING ADDED?!!!?
		user_array+=( $response )
		#user_array+=($response)
	fi
done

