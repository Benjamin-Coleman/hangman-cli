Game starts
	User class instance is created with 0 wins and 0 losses
	Prompted for name
		name assigned to user.name
	Answer word is selected from possible words
	 	Prints "___  " times Answer word.length
		Puts "You have Game.guesses_remaining guesses left"
		Puts "Guess a letter"
	User inputs character guess
		Game loops through every letter of answer word to see if match
			if match fill in correct letters
				update answer hash
				display new "___" showing all correct letters
				gueses remaining unchanged
			if no matches
				display new "___" unchanged results
				guesses remaining -1
			check if game over
				if all sum hash.values = answer.length 
					user win +1
				if guesses remaining < 0 
					user loss +1
			reprompt for another guess if game not over
