#!/bin/bash

# TODO:
# -make read answers in line with questions
# -allow scoring and rolling to be repeated over multiple rounds
# -expand score options (straights etc.)
# -add a numeric score i.e. 22333 scores higher than 11222
# -add a high score option that can be overwritten

# function to roll a die
roll_die() {
	echo $(( (RANDOM % 6) + 1 ))
}

# function to reroll dice
reroll_dice() {

	while true; do
		echo -e "Would you like to reroll any dice? (y/n)"
		read reroll
		reroll=$(echo "$reroll" | tr '[:upper:]' '[:lower:]') 		# converts upper case to lower case to handle incorrect inputs

		if [[ $reroll == "y" ]]; then
			echo -e "\nWhich dice would you like to reroll? (type 1 for left-most die, then 2 3 etc. each separated by a space)"
			read -a dice
			
		# checks at least one valid die selected	
		valid=true
		for die in "${dice[@]}"; do
		  if ! [[ "$die" =~ ^[1-5]$ ]]; then
			valid=false
			break
		  fi
		done
		
		# checks the user hasn't input the same die multiple times
		#for die in "${dice[@]}"; do
		#  if ; then
		#	valid=false
		#	break
		#  fi
		#done

		if [[ ${#dice[@]} -lt 1 || $valid == false ]]; then
			echo -e "\nNo dice selected or invalid dice given. Please enter valid input.\n"
			continue 		# restarts the loop to ask for valid input
		else		
		  # reroll the selected dice
			echo ""
			for i in "${dice[@]}"; do
				eval "die$i=$(roll_die)"  # reroll the specific die and assign it to the variable
				eval "echo -e Die $i has been rerolled to: \${die$i}"  # Print the new value of the rerolled die
			done
			
			(( roll_counter++ ))
			sort_dice
			
			echo -e "\nNew roll: $die1 $die2 $die3 $die4 $die5"
			echo -e "\nYou have rolled $roll_counter time(s). $(($roll_limit - $roll_counter)) roll(s) remaining"
			break  		# Exit the loop if input is valid
		fi
			
		elif [[ $reroll == "n" ]]; then
			echo -e "\nDice will be scored!"
			break # valid input so loop is broken
			
		else
			echo -e "\nInvalid input. Please enter 'y' or 'n'.\n"
			continue
			
		fi
		
	done
}

# function to score dice
score_dice() {
	echo -e "Scoring dice..."
	
	if [[ $die1 == $die5 ]]; then
		echo -e "\nYou got five of a kind!\n"
		
	elif [[ $die1 == $die4 ||  $die2 == $die5 ]]; then
		echo -e "\nYou got four of a kind!\n"
		
	elif [[ ($die1 == $die3 && $die4 == $die5) || ($die1 == $die2 && $die3 == $die5) ]]; then
		echo -e "\nYou got a full house!\n"
		
	elif [[ $die1 == $die3 || $die2 == $die4 || $die3 == $die5 ]]; then
		echo -e "\nYou got three of a kind!\n"
		
	elif [[ ($die1 == $die2 && $die3 == $die4) || ($die2 == $die3 && $die4 == $die5) || ($die1 == $die2 && $die4 == $die5) ]]; then
		echo -e "\nYou got two pair!\n"
		
	elif [[ $die1 == $die2 || $die2 == $die3 || $die3 == $die4 || $die4 == $die5 ]]; then
		echo -e "\nYou got a pair!\n"
		
	else
		echo -e "\nNo score :(!\n"
		
	fi
}

# function to sort dice (bubble sort)
sort_dice () {
	while true; do
	swapped=false
	
	# temporary variables used for sorting
	sort1=$die1
	sort2=$die2
	sort3=$die3
	sort4=$die4
	sort5=$die5
	
	if [[ $sort1 -gt  $sort2 ]]; then
		die1=($sort2)
		die2=($sort1)
		swapped=true
		continue
	elif [[ $sort2 -gt  $sort3 ]]; then
		die2=($sort3)
		die3=($sort2)
		swapped=true
		continue
	elif [[ $sort3 -gt  $sort4 ]]; then
		die3=($sort4)
		die4=($sort3)
		swapped=true
		continue
	elif [[ $sort4 -gt  $sort5 ]]; then
		die4=($sort5)
		die5=($sort4)
		swapped=true
		continue
	elif swapped=false; then
		break
	else	
		continue
	fi
	
	done
}

# setting initial variables

roll_limit=3		# sets the number of rolls allowed per turn
roll_counter=1 		# keeps track of how many times user has rolled
round_counter=1		# keeps track of current turn

echo -e "Round $round_counter"

# initial roll, roll five 6-sided dice and assign each die to variable
for i in {1..5}; do
	eval die$i=$(roll_die)
done

sort_dice

# print dice roll
echo -e "you rolled: $die1 $die2 $die3 $die4 $die5"
echo -e "\nYou have rolled $roll_counter time(s). $(($roll_limit - $roll_counter)) roll(s) remaining\n"

# loops the reroll function allowing the user up to roll_limit rolls per round
while true; do
	if [[ $roll_counter -lt $roll_limit && $reroll != "n" ]]; then
		reroll_dice		# calls reroll dice function
	elif [[ $reroll == n ]]; then
		break
	else
		echo -e "Dice will be scored!"
		break
	fi
done

roll_counter=1		# resets roll counter
(( round_counter++ ))	# increases turn number by 1

score_dice