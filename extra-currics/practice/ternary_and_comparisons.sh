# int a = (b == 5) ? c : d;
# a=$([ "$b" == 5 ] && echo "$c" || echo "$d")

# equivalency with integers 
#read -p "1 or 2?" answer
#[[ $answer -eq 1 ]] && a="still on!" || a="off now!"
#echo $a

# equivalency with strings
read -p "yes or no?" answer
 [[ $answer = "yes" ]] && a="still on!" || a="off now!"
 echo $a

# did not work
#a=$([ "$answer" == 1] && [echo "first echo"] || echo "second echo")
