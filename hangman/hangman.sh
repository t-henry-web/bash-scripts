#!/bin/bash

# TODO:
# Maintain symbols - etc from original word, and display in blank word i.e. "_ _ - _ _"

# function to pick random word from external text file
generate_word() {
    word=$(shuf -n 1 $wordlist)
	unfiltered_word=$word # stores unfiltered word to be recalled at end of game
	word=${word,,}
	word=$(echo "$word" | tr -cd '[:alpha:]') # filter word
    length=${#word}  # find length of word
		    
    # create an array to store each character of the word
    for ((i = 0; i < length; i++)); do
        character[$i]="${word:i:1}"  # store each character in an array
    done
}

# function to display the word with hidden letters
display_word () {
    for ((i = 0; i < length; i++)); do
        hidden[$i]="_"  # initially hide all letters
    done
    echo "${hidden[*]}"
    echo ""
}

# function to guess a letter
guess () {
    while true; do
        echo -e -n "\nGuess a letter: "
        read guess
		guess="${guess,,}" # filters guessed letter to be lower case
		
		# check guess is a single character
		if ! [[ $guess =~ ^[a-z]$ ]]; then
			echo -e "Invalid guess. Please guess a single letter."
			continue
		fi
        
        # check the letter hasn't been guessed before
        for letter in "${letters_guessed[@]}"; do
            if [[ "$letter" == "$guess" ]]; then
                echo -e "Letter already guessed, guess another letter."
                continue 2  # exit to the while loop to prompt for a new guess
            fi
        done
        
        letters_guessed+=("$guess")  # add guessed letter to the list
        
        guess_found=false
        
        # check if the guessed letter is in the word
        for ((i = 0; i < length; i++)); do
            if [[ $guess == ${character[$i]} ]]; then
                hidden[$i]="${character[$i]}"  # Reveal the letter in the hidden array
                guess_found=true
				echo -e "Correct! Guessed letters: ${letters_guessed[@]}"
            fi
        done
        
        # If the guess was incorrect, increment guesses
        if ! $guess_found; then
            echo -e "Nope! Guessed letters: ${letters_guessed[@]}"
            guesses=$((guesses + 1))
        fi
        
        echo -e "\n${hidden[*]}"  # Display the current state of the word
        
        break  # Exit the loop after processing one guess
    done
}

# function to check if the word is fully guessed
check_word_guessed() {
    for ((i = 0; i < length; i++)); do
        if [[ ${hidden[$i]} == "_" ]]; then
            return 1  # Word is not fully guessed yet
        fi
    done
    return 0  # Word is fully guessed
}

# define variables
wordlist="wordlist.txt"  # defaults file that word will be read from
guess_limit=12            # number of guesses before game over
guesses=0                 # number of guesses done by player
guesses_remaining=$((guess_limit - guesses))  # tracks guesses remaining
letters_guessed=()       # define empty array to store guessed letters

# main script

# select text file
echo -e "Select a word list to play from:"
echo "$(ls *.txt | sed 's/\.txt$//g' | tr '\n' ' ')"
read wordlist
wordlist=$wordlist.txt

echo -e -n "\nYour word: "
generate_word
display_word

echo -e "$guesses_remaining guesses remaining."

# main game loop
while true; do
    if [[ $guesses -lt $guess_limit ]]; then
        guess
        guesses_remaining=$((guess_limit - guesses))  # update guesses remaining
        
        if check_word_guessed; then
            echo -e "\nCongratulations! You've guessed the word!\nThe word was $unfiltered_word!\n"
            break
        fi
        
        if [[ $guesses -ge $guess_limit ]]; then
            echo -e "\nGame over! You've run out of guesses. The word was $unfiltered_word"
            break
        fi
        
        echo -e "$guesses_remaining guesses remaining."
    else
        break
    fi
done
