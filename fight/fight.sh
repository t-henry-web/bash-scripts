#!/bin/bash

# Dice based fighting game

# fighter stats. hp = hit points, spd = speed, atk = attack, blk = block, grb = grab, ai = move selection

# TODO:
# Verify user inputs
# Prevent HP values going negative (filter to 0)
# Add decision tree for enemy AI (decisions based on player roll and enemy roll)
# Add more charaters
# Implement a distance mechanic so fighters can move/jump/evade. Add ranged fireball attacks
# Full playtesting. Implement test modes (DONE FOR AI DICE)
# Give an advantage to a successful block, such as going first next turn if there is a speed check

# Shisaka - Jack of all trades fighter
shi_hp=8
shi_spd_die=('2' '3' '3' '3' '3' '4')
shi_atk_die=('2' '3' '3' '3' '3' '4')
shi_blk_die=('1' '2' '2' '2' '2' '3')
shi_grb_die=('1' '1' '2' '2' '3' '3')
shi_ai_die=('1' '1' '1' '1' '1' '2' '2' '2' '3' '3')

# Takemo - Higher health and grappling focused
tak_hp=10
tak_spd_die=('1' '1' '2' '2' '2' '3')
tak_atk_die=('2' '2' '2' '3' '3' '3')
tak_blk_die=('2' '2' '2' '3' '3' '4')
tak_grb_die=('2' '3' '3' '3' '4' '4')
tak_ai_die=('1' '1' '2' '2' '2' '2' '3' '3' '3' '3')

# define variables to store stats for player and opponent depending on choice of fighter
pl_hp=0
pl_spd_die=('0' '0' '0' '0' '0' '0')
pl_atk_die=('0' '0' '0' '0' '0' '0')
pl_blk_die=('0' '0' '0' '0' '0' '0')
pl_grb_die=('0' '0' '0' '0' '0' '0')

op_hp=0
op_spd_die=('0' '0' '0' '0' '0' '0')
op_atk_die=('0' '0' '0' '0' '0' '0')
op_blk_die=('0' '0' '0' '0' '0' '0')
op_grb_die=('0' '0' '0' '0' '0' '0')
op_ai_die=('0' '0' '0' '0' '0' '0' '0' '0' '0' '0')

# function to roll die
roll () {
    local dice_array=("${!1}")
    local index=$((RANDOM % ${#dice_array[@]}))
    echo "${dice_array[$index]}"
}

# function to choose player fighter
choose_fighter () {
    while true; do
        echo -e "Choose your fighter!:\n1) Shisaka the Karate fighter\n2) Takemo the Sumo wrestler!"
        read -p "Enter choice: " choice
        
        if [[ $choice == 1 ]]; then
            player=Shisaka
            pl_hp=$shi_hp
            pl_spd_die=("${shi_spd_die[@]}")
            pl_atk_die=("${shi_atk_die[@]}")
            pl_blk_die=("${shi_blk_die[@]}")
            pl_grb_die=("${shi_grb_die[@]}")

            opponent=Takemo
            op_hp=$tak_hp
            op_spd_die=("${tak_spd_die[@]}")
            op_atk_die=("${tak_atk_die[@]}")
            op_blk_die=("${tak_blk_die[@]}")
            op_grb_die=("${tak_grb_die[@]}")
			op_ai_die=("${tak_ai_die[@]}")
            break
            
        elif [[ $choice == 2 ]]; then
            player=Takemo
            pl_hp=$tak_hp
            pl_spd_die=("${tak_spd_die[@]}")
            pl_atk_die=("${tak_atk_die[@]}")
            pl_blk_die=("${tak_blk_die[@]}")
            pl_grb_die=("${tak_grb_die[@]}")

            opponent=Shisaka
            op_hp=$shi_hp
            op_spd_die=("${shi_spd_die[@]}")
            op_atk_die=("${shi_atk_die[@]}")
            op_blk_die=("${shi_blk_die[@]}")
            op_grb_die=("${shi_grb_die[@]}")
			op_ai_die=("${shi_ai_die[@]}")
            break
            
        else
            echo -e "\nInvalid input. Please type 1 for Shisaka, or 2 for Takemo\n"
            continue
        fi
    done
}

# function to display fighter stats
display_stats () {
    echo -e "\nYou chose $player:"
    echo -e "HP: $pl_hp"
    echo -e "Speed Die: ${pl_spd_die[@]}"
    echo -e "Attack Die: ${pl_atk_die[@]}"
    echo -e "Block Die: ${pl_blk_die[@]}"
    echo -e "Grab Die: ${pl_grb_die[@]}\n"
    
    echo -e "Your opponent is $opponent:"
    echo -e "HP: $op_hp"
    echo -e "Speed Die: ${op_spd_die[@]}"
    echo -e "Attack Die: ${op_atk_die[@]}"
    echo -e "Block Die: ${op_blk_die[@]}"
    echo -e "Grab Die: ${op_grb_die[@]}\n"
}

# function to perform speed check in case both players choose same move
speed_check () {
	echo -e "Speed check!"

	while true; do
		pl_spd=$(roll pl_spd_die[@])
		op_spd=$(roll op_spd_die[@])
		
		# rerolls in case of speed tie
		if [[ $pl_spd -eq $op_spd ]]; then
			continue
		else
			if [[ $pl_spd -gt $op_spd ]]; then
				echo -e "Player is faster than enemy $opponent"
			else
				echo -e "$opponent is faster than player"
			fi
			break
		fi	
	done
}

player_turn () {

	pl_atk=$(roll pl_atk_die[@])
	pl_blk=$(roll pl_blk_die[@])
	pl_grb=$(roll pl_grb_die[@])
	echo -e "\nYou rolled: \nAttack: $pl_atk, Block: $pl_blk, Grab: $pl_grb"
	
	op_atk=$(roll op_atk_die[@])
	op_blk=$(roll op_blk_die[@])
	op_grb=$(roll op_grb_die[@])
	echo -e "\n$opponent rolled: \nAttack: $op_atk, Block: $op_blk, Grab: $op_grb"
	
	while true; do
	
	echo -e "\nWhat will you do:"
	echo -e "1) Attack"
	echo -e "2) Block"
	echo -e "3) Grab"
	
	read pl_decision
	
	if [[ $pl_decision == 1 ]]; then
		pl_move=$pl_atk
	elif [[ $pl_decision == 2 ]]; then
		pl_move=$pl_blk
	elif [[ $pl_decision == 3 ]]; then
		pl_move=$pl_grb
	else
		echo -e "Invalid input, select 1, 2, or 3."
		continue
	fi
	
	opponent_move
	calculate_damage
	break
	
	done
}

# function to determine opponent's move
opponent_move () {
	op_decision=$(roll op_ai_die[@])
	
	if [[ $op_decision == 1 ]]; then
		op_move=$op_atk
		echo -e "\n$opponent decides to Attack"
	elif [[ $op_decision == 2 ]]; then
		op_move=$op_blk
		echo -e "\n$opponent decides to Block"
	elif [[ $op_decision == 3 ]]; then
		op_move=$op_grb
		echo -e "\n$opponent decides to Grab"
	else
		echo "Error determining opponent move"
	fi

}

# function to calculate damage 
calculate_damage () {

# attack beats grab, grab beats block, block beats attack. Speed check on matched attacks

	# both players attack
	if [[ $pl_decision == 1 && $op_decision == 1 ]]; then
		speed_check		# both attack so perform speed check to see who attacks first
		if [[ $pl_spd -gt $op_spd ]]; then
			op_hp=$(( $op_hp - $pl_atk ))
			echo -e "Player hits $opponent for $pl_atk!"
			knocked_out		# checks opponent isn't knocked out before continuing
			pl_hp=$(( $pl_hp - $op_atk ))
			echo -e "$opponent hits Player for $op_atk!"
		else
			pl_hp=$(( $pl_hp - $op_atk ))
			echo -e "$opponent hits Player for $op_atk!"
			knocked_out		# checks player isn't knocked out before continuing
			op_hp=$(( $op_hp - $pl_atk ))
			echo -e "Player hits $opponent for $pl_atk!"
		fi
			
	# player attacks and opponent blocks
	elif [[ $pl_decision == 1 && $op_decision == 2 ]]; then
		damage_through=$(( $pl_atk - $op_blk ))
		if [[ $damage_through -gt 0 ]]; then
			op_hp=$(( $op_hp - $damage_through ))
			echo -e "$op_blk damage blocked! Player attacked for $damage_through!"
		else
			echo -e "$opponent blocked all damage!"
		fi
	
	# player attacks and opponent grabs
	elif [[ $pl_decision == 1 && $op_decision == 3 ]]; then
	# attack beats grab
		op_hp=$(( $op_hp - $pl_atk ))
		echo -e "Player attacks for $pl_atk! $opponent's grab fails!"
	
	# player blocks and opponent attacks
	elif [[ $pl_decision == 2 && $op_decision == 1 ]]; then
		damage_through=$(( $op_atk - $pl_blk ))
		if [[ $damage_through -gt 0 ]]; then
			pl_hp=$(( $pl_hp - $damage_through ))
			echo -e "$pl_blk damage blocked! $opponent attacked for $damage_through!"
		else
			echo -e "Player blocked all damage!"
		fi
			
	# both players block
	elif [[ $pl_decision == 2 && $op_decision == 2 ]]; then	
		echo -e "Both players blocked. Nothing happened!"
		
	# player block and opponent grabs
	elif [[ $pl_decision == 2 && $op_decision == 3 ]]; then
	# grab beats block
		pl_hp=$(( $pl_hp - $op_blk ))
		echo -e "$opponent grabs the player, $op_grb damage!! Player can't block!"
	
	# player grabs and opponent attacks
	elif [[ $pl_decision == 3 && $op_decision == 1 ]]; then
	pl_hp=$(( $pl_hp - $op_atk ))
		echo -e "$opponent attacks for $op_atk! Player's grab fails!"
	
	# player grabs and opponent blocks
	elif [[ $pl_decision == 3 && $op_decision == 2 ]]; then
		op_hp=$(( $op_hp - $pl_blk ))
		echo -e "Player grabs $opponent, $pl_grb damage!! $opponent can't block!"
		
	# both players grab
	elif [[ $pl_decision == 3 && $op_decision == 3 ]]; then
		speed_check		# both grab so perform speed check
		if [[ $pl_spd -gt $op_spd ]]; then
			op_hp=$(( $op_hp - $pl_grb ))
			echo -e "Player grabs $opponent. $pl_grb damage!"
			knocked_out		# checks opponent isn't knocked out before continuing
			echo -e "$opponent is stunned. Can't attack!"
		else
			pl_hp=$(( $pl_hp - $op_grb ))
			echo -e "$opponent grabs Player. $op_grb damage!"
			knocked_out		# checks player isn't knocked out before continuing
			op_hp=$(( $op_hp - $pl_atk ))
			echo -e "Player  is stunned. Can't attack!"
		fi
		
	fi
	
	echo -e "Player $player has $pl_hp health, Enemy $opponent has $op_hp health."
	
	knocked_out
}

# function to check hp greater than 0
knocked_out () {
	health_zero=0
	if [[ $pl_hp -le 0 ]]; then
		health_zero=true
		echo -e "\nYou have been knocked out! You lose!"
		exit 0
	elif [[ $op_hp -le 0 ]]; then
		health_zero=true
		echo -e "\n$opponent has been knocked out! You win!"
		exit 0
	fi
}

#function to test ai dice probabilities working correctly
test_ai () {
attacks=0
blocks=0
grabs=0
echo "enemy ai rolls test"
for ((i = 0 ; i < 100 ; i++)); do
	ai=$(roll op_ai_die[@])
	if [[ $ai == 1 ]]; then
		((attacks++))
	elif [[ $ai == 2 ]]; then
		((blocks++))
	elif [[ $ai == 3 ]]; then
		((grabs++))
	fi
done
echo "$attacks attacks"
echo "$blocks blocks"
echo "$grabs grabs"
}


# main game loop

choose_fighter
display_stats

echo -e "FIGHT!"

# breaks game loop if either fighter's health drops to 0
while [[ $health_zero != true ]]; do
	player_turn
done

echo -e "Game over!"