#!/bin/bash
# accessing and/or printing array objects

# intiate an array
read -a arr <<< "one two three"

# PRINT ARRAY

# this will not print the array, only the first object
# echo $arr

# to print, you have to iterate through the array BOO
# for loop:
for i in ${arr[@]}
do
	echo $i
done

