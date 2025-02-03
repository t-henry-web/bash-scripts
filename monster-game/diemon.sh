#!bin/bash

# Dice based creature battle RPG

# TODO:
# Tutorial
# Multiple moves per diemon
# Multiple die rolls, allocate to attack of choice
# Options to heal, block etc
# Elemental damage
# Diemon balancing
# Give descriptions of each diemon and ask for confirmation over choice.
# Make code more scaleable, adding additional monsters, >6 sided dice etc.


# function to choose opponent's diemon
rival_choice () {
	if [[ $diemon == "zuphlet" ]]; then
		rival_diemon="ignipup"
	elif [[ $diemon == "urubub" ]]; then
		rival_diemon="zuphlet"
	elif [[ $diemon == "ignipup" ]]; then
		rival_diemon="apsipole"
	elif [[ $diemon == "apsipole" ]]; then
		rival_diemon="urubub"
	fi
}

# function to update active and opponent stats
update_stats () {
    # Directly assign diemon stats based on player choice
    case $diemon in
        "zuphlet")
            diemon_health=$zuphlet_health
            diemon_attack=("${zuphlet_attack[@]}")
            diemon_evasion=("${zuphlet_evasion[@]}")
            diemon_speed=$zuphlet_speed
            ;;
        "urubub")
            diemon_health=$urubub_health
            diemon_attack=("${urubub_attack[@]}")
            diemon_evasion=("${urubub_evasion[@]}")
            diemon_speed=$urubub_speed
            ;;
        "ignipup")
            diemon_health=$ignipup_health
            diemon_attack=("${ignipup_attack[@]}")
            diemon_evasion=("${ignipup_evasion[@]}")
            diemon_speed=$ignipup_speed
            ;;
        "apsipole")
            diemon_health=$apsipole_health
            diemon_attack=("${apsipole_attack[@]}")
            diemon_evasion=("${apsipole_evasion[@]}")
            diemon_speed=$apsipole_speed
            ;;
    esac

    # Directly assign rival stats based on opponent diemon choice
    case $rival_diemon in
        "zuphlet")
            rival_health=$zuphlet_health
            rival_attack=("${zuphlet_attack[@]}")
            rival_evasion=("${zuphlet_evasion[@]}")
            rival_speed=$zuphlet_speed
            ;;
        "urubub")
            rival_health=$urubub_health
            rival_attack=("${urubub_attack[@]}")
            rival_evasion=("${urubub_evasion[@]}")
            rival_speed=$urubub_speed
            ;;
        "ignipup")
            rival_health=$ignipup_health
            rival_attack=("${ignipup_attack[@]}")
            rival_evasion=("${ignipup_evasion[@]}")
            rival_speed=$ignipup_speed
            ;;
        "apsipole")
            rival_health=$apsipole_health
            rival_attack=("${apsipole_attack[@]}")
            rival_evasion=("${apsipole_evasion[@]}")
            rival_speed=$apsipole_speed
            ;;
    esac
}

# battle loop

battle () {
    first_turn=true  # flag to check if it's the first turn
    
    while [[ $diemon_health -gt 0 && $rival_health -gt 0 ]]; do		# while both diemon are alive
        
        if [[ $first_turn == true ]]; then
            # Speed check only for the first turn
            if [[ $diemon_speed -gt $rival_speed ]]; then
                # Player's diemon attacks first
                echo -e "$diemon is faster! $diemon's turn!"
                
                # Filter out 0 values from the attack array manually
                filtered_attack_values=()
                for atk in "${diemon_attack[@]}"; do
                    if [[ $atk -ne 0 ]]; then
                        filtered_attack_values+=($atk)
                    fi
                done
                
                # Check if we have valid attack values to avoid selecting an empty array
                if [[ ${#filtered_attack_values[@]} -gt 0 ]]; then
                    p_atk=$(shuf -e "${filtered_attack_values[@]}" -n 1)
                    echo -e "$diemon attacked for $p_atk!\n"
                else
                    echo "Error: No valid attack values available for $diemon!"
                    break
                fi

                # Roll for evasion for rival diemon
                r_evasion_roll=$(shuf -e "${rival_evasion[@]}" -n 1)
                if [[ $r_evasion_roll -eq 1 ]]; then
                    # Evasion failed (attack hits)
                    echo "$rival_diemon could not evade the attack!"
                    rival_health=$((rival_health - p_atk))
                else
                    # Evasion succeeded (attack misses)
                    echo "$rival_diemon evaded the attack!"
                fi

                # Check if the rival is defeated
                if [[ $rival_health -le 0 ]]; then
                    echo "$rival_diemon has been defeated! You win!"
                    break
                fi

                # Display rival's health only if greater than 0
                if [[ $rival_health -gt 0 ]]; then
                    echo -e "$rival_diemon's health: $rival_health\n"
                fi

                # Rival's diemon attacks second
                echo -e "$rival_diemon's turn!"
                r_atk=$(shuf -e "${rival_attack[@]}" -n 1)
                echo -e "$rival_diemon attacked for $r_atk!\n"

                # Roll for evasion for player's diemon
                p_evasion_roll=$(shuf -e "${diemon_evasion[@]}" -n 1)
                if [[ $p_evasion_roll -eq 1 ]]; then
                    # Evasion failed (attack hits)
                    echo "$diemon could not evade the attack!"
                    diemon_health=$((diemon_health - r_atk))
                else
                    # Evasion succeeded (attack misses)
                    echo "$diemon evaded the attack!"
                fi

                # Check if the player's diemon is defeated
                if [[ $diemon_health -le 0 ]]; then
                    echo "$diemon has been defeated! You lose!"
                    break
                fi

                # Display player's diemon health only if greater than 0
                if [[ $diemon_health -gt 0 ]]; then
                    echo -e "$diemon's health: $diemon_health\n"
                fi

            else
                # Rival's diemon attacks first
                echo -e "$rival_diemon is faster! $rival_diemon's turn!"
                r_atk=$(shuf -e "${rival_attack[@]}" -n 1)
                echo -e "$rival_diemon attacked for $r_atk!\n"

                # Roll for evasion for player's diemon
                p_evasion_roll=$(shuf -e "${diemon_evasion[@]}" -n 1)
                if [[ $p_evasion_roll -eq 1 ]]; then
                    # Evasion failed (attack hits)
                    echo "$diemon could not evade the attack!"
                    diemon_health=$((diemon_health - r_atk))
                else
                    # Evasion succeeded (attack misses)
                    echo "$diemon evaded the attack!"
                fi

                # Check if the player's diemon is defeated
                if [[ $diemon_health -le 0 ]]; then
                    echo "$diemon has been defeated! You lose!"
                    break
                fi

                # Display player's diemon health only if greater than 0
                if [[ $diemon_health -gt 0 ]]; then
                    echo -e "$diemon's health: $diemon_health\n"
                fi

                # Player's diemon attacks second
                echo -e "$diemon's turn!"
                
                # Filter out 0 values from the attack array manually
                filtered_attack_values=()
                for atk in "${diemon_attack[@]}"; do
                    if [[ $atk -ne 0 ]]; then
                        filtered_attack_values+=($atk)
                    fi
                done
                
                # Check if we have valid attack values to avoid selecting an empty array
                if [[ ${#filtered_attack_values[@]} -gt 0 ]]; then
                    p_atk=$(shuf -e "${filtered_attack_values[@]}" -n 1)
                    echo -e "$diemon attacked for $p_atk!\n"
                else
                    echo "Error: No valid attack values available for $diemon!"
                    break
                fi

                # Roll for evasion for rival diemon
                r_evasion_roll=$(shuf -e "${rival_evasion[@]}" -n 1)
                if [[ $r_evasion_roll -eq 1 ]]; then
                    # Evasion failed (attack hits)
                    echo "$rival_diemon could not evade the attack!"
                    rival_health=$((rival_health - p_atk))
                else
                    # Evasion succeeded (attack misses)
                    echo "$rival_diemon evaded the attack!"
                fi

                # Check if the rival is defeated
                if [[ $rival_health -le 0 ]]; then
                    echo "$rival_diemon has been defeated! You win!"
                    break
                fi

                # Display rival's health only if greater than 0
                if [[ $rival_health -gt 0 ]]; then
                    echo -e "$rival_diemon's health: $rival_health\n"
                fi
            fi

            first_turn=false  # Set flag to false after the first turn

        else
            # After the first turn, attacks alternate regardless of speed

            # Player's diemon attacks
            echo -e "$diemon's turn!"
            filtered_attack_values=()
            for atk in "${diemon_attack[@]}"; do
                if [[ $atk -ne 0 ]]; then
                    filtered_attack_values+=($atk)
                fi
            done
            
            # Check if we have valid attack values to avoid selecting an empty array
            if [[ ${#filtered_attack_values[@]} -gt 0 ]]; then
                p_atk=$(shuf -e "${filtered_attack_values[@]}" -n 1)
                echo -e "$diemon attacked for $p_atk!"
            else
                echo "Error: No valid attack values available for $diemon!"
                break
            fi

            # Roll for evasion for rival diemon
            r_evasion_roll=$(shuf -e "${rival_evasion[@]}" -n 1)
            if [[ $r_evasion_roll -eq 1 ]]; then
                # Evasion failed (attack hits)
                echo "$rival_diemon could not evade the attack!"
                rival_health=$((rival_health - p_atk))
            else
                # Evasion succeeded (attack misses)
                echo "$rival_diemon evaded the attack!"
            fi

            # Check if the rival is defeated
            if [[ $rival_health -le 0 ]]; then
                echo "$rival_diemon has been defeated! You win!"
                break
            fi

            # Display rival's health only if greater than 0
            if [[ $rival_health -gt 0 ]]; then
                echo -e "$rival_diemon's health: $rival_health\n"
            fi

            # Rival's diemon attacks
            echo -e "$rival_diemon's turn!"
            r_atk=$(shuf -e "${rival_attack[@]}" -n 1)
            echo -e "$rival_diemon attacked for $r_atk!"

            # Roll for evasion for player's diemon
            p_evasion_roll=$(shuf -e "${diemon_evasion[@]}" -n 1)
            if [[ $p_evasion_roll -eq 1 ]]; then
                # Evasion failed (attack hits)
                echo "$diemon could not evade the attack!"
                diemon_health=$((diemon_health - r_atk))
            else
                # Evasion succeeded (attack misses)
                echo "$diemon evaded the attack!"
            fi

            # Check if the player's diemon is defeated
            if [[ $diemon_health -le 0 ]]; then
                echo "$diemon has been defeated! You lose!"
                break
            fi

            # Display player's diemon health only if greater than 0
            if [[ $diemon_health -gt 0 ]]; then
                echo -e "$diemon's health: $diemon_health\n"
            fi
        fi
    done
}

# set variables

diemon_list=("zuphlet" "urubub" "ignipup" "apsipole")
rival_diemon=""

# Zuphlet
zuphlet_health=7
zuphlet_attack=("2" "4" "4" "4" "6" "6")
zuphlet_evasion=("0" "0" "0" "1" "1" "1")
zuphlet_speed=10

# Urubub
urubub_health=10
urubub_attack=("1" "3" "3" "3" "4" "4")
urubub_evasion=("0" "1" "1" "1" "1" "1")
urubub_speed=5

# Ignipup
ignipup_health=7
ignipup_attack=("2" "3" "4" "4" "5" "6")
ignipup_evasion=("0" "0" "1" "1" "1" "1")
ignipup_speed=9

# Apsipole
apsipole_health=8
apsipole_attack=("2" "2" "3" "4" "4" "5")
apsipole_evasion=("0" "0" "1" "1" "1" "1")
apsipole_speed=8

# store active diemon stats
diemon_health=0
diemon_attack=("0" "0" "0" "0" "0" "0")
diemon_evasion=("" "" "" "" "" "")
diemon_speed=0

# store opponent diemon stats
rival_health=0
rival_attack=("0" "0" "0" "0" "0" "0")
rival_evasion=("" "" "" "" "" "")
rival_speed=0


# main game loop

echo -e -n "Choose your Diemon!: "
echo -e "${diemon_list[*]}\n"
read diemon

rival_choice		# choose rival's diemon based on player choice

update_stats

# After updating stats, display the player's diemon information
echo -e "You chose $diemon!\n"
echo "$diemon's health: $diemon_health"
echo "$diemon's attack values: ${diemon_attack[@]}"
echo -e -n "$diemon's evasion values: "
for evasion in "${diemon_evasion[@]}"; do
    echo -n "$evasion "
done
echo -e "\n$diemon's speed: $diemon_speed\n"

# Display rival's information
echo -e "Your rival chose $rival_diemon!\n"
echo "$rival_diemon's health: $rival_health"
echo "$rival_diemon's attack values: ${rival_attack[@]}"
echo -e -n "$rival_diemon's evasion values: "
for evasion in "${rival_evasion[@]}"; do
    echo -n "$evasion "
done
echo -e "\n$rival_diemon's speed: $rival_speed\n"


battle