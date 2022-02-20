#!/bin/bash

# write flawed function to check user input for date, time, and casino game being played

function input_validation {

# $1 and $2 are local variables for passing arguments into the input_validation function
if echo "$1" | grep -q "$2"
then
	echo "Thank you for following basic input instructions! "
else
	echo "No, that is what I asked. Exiting..."
	exit 
fi
}

# set regex parameters for input validation, again: flawed, I know. Just wanted the experience of doing through regex. Also, I originally had a white space in the $time input but bash was interpreting it not as a single string with white space between two words but a new line between two strings. It was weird.

date_format='^[0-1][0-9][0-3][0-9]$'
time_format='^[0-9][0-9][AP][M]$'

# prompt, store, validate, and echo back user input for date 
read -p 'Enter a date in 4-digit format such as "0310" for March 10th: ' date
input_validation $date $date_format
echo "The date you have entered is $date."

# prompt, store, validate, reformat, and echo back user input for time
read -p 'Enter the time in the following format: "XXYY" where XX is the time and YY is the AM/PM. (For example: 05AM): ' time 
input_validation $time $time_format

# extract the AM/PM field from input
am_pm=" ${time:2:3}"

# reformat the time input
search_time=${time:0:2}:00:00$am_pm

# echo back to user because it's nice to feel heard
echo "The time you have entered is $search_time"

# search the appropriate Dealer Schedule file. Yes, I'm aware this only works if the files in question are in the same directory as the script so I have, ahem, moved those schedule files here...:D
file_name=${date}_Dealer_schedule

# Debugging line left in
# echo "The file name to search for $date is $file_name"

# output the results to User if successful

output=$(cat $file_name | grep "$search_time" | awk '{print $4, $5}')
echo "The dealer who was working on $date at $search_time is: $output"

# Yes, I'm also aware I could have left an error message and a loop to restart the program in case of error but it was indicated to me by my tutor that this isn't really the "purpose" of bash scripting and to refocus my time on practicing more relevant automation/networking scripts. I'm VERY open to feedback if you disagree with tutor's suggestions?

# Thank you for reading this assignment!
# Effy
