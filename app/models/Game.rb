require 'pry'

require_relative 'Answer'
require_relative 'User'

class Game
	attr_accessor :answer, :display_letters

	def ascii_header
"
888                                                           
888                                                           
888                                                           
88888b.  8888b. 88888b.  .d88b. 88888b.d88b.  8888b. 88888b.  
888 88b    88b888 88bd88P88b888 888 88b    88b888 88b 
888  888.d888888888  888888  888888  888  888.d888888888  888 
888  888888  888888  888Y88b 888888  888  888888  888888  888 
888  888Y888888888  888 Y88888888  888  888Y888888888  888 
                             888                              
                        Y8b d88P                              
                         Y88P" 

     end                             


	def initialize
		@answer = get_answer_word.split("")
		@display_letters = Array.new(@answer.length){"_"}
		@guesses_remaining = 7
		@incorrect_guess_history = []
		@correct_guess_history = []
		@user_guess = ""
		@game_state = "in progress"
		system 'clear'
		puts "#{ascii_header}"
		puts "What's your name"
		@active_user = ""
		@user_name = gets.chomp
		@active_user = User.find_or_create_by_name(@user_name)
		until @game_state == "complete"
			play
		end
	end

	def play
		input_guess
		validate_guess
		check_guess
	end

	def input_guess
		puts "Enter a letter and hit enter:"
		@user_guess = gets.chomp.downcase
	end

	def validate_guess
		is_quit?
		is_letter?
		is_one_char?
		has_been_guessed_correctly?
		has_been_guessed_incorrectly?
	end

	def is_quit?
		if @user_guess == "quit"
			puts "Are you sure you want to quit? (y/n)"
			yes_no = gets.chomp.downcase
			if yes_no == "y"
				puts "#{["Whatever bruh", "Fine, quitter", "You would have lost anyways", "Meh"].sample}"
				abort
			else
				return input_guess
			end
		end
	end

	def is_letter?
		alphabet = ("a".."z").to_a
		if !alphabet.include?(@user_guess)
			puts "Only letters please!"
			return input_guess
		end
	end

	def is_one_char?
		if @user_guess.length > 1
			puts "Only one letter per guess please!"
			return input_guess
		end
	end

	def has_been_guessed_correctly?
		if @correct_guess_history.include?(@user_guess)
			puts "You have already correctly guessed #{@user_guess}!"
			return input_guess
		end
	end	

	def has_been_guessed_incorrectly?
		if @incorrect_guess_history.include?(@user_guess)
			puts "You have already incorrectly guessed #{@user_guess}!"
			return input_guess
		end
	end

	def enter_name
		puts "Please enter your name"
			name_input = gets.chomp
			name_input
	end

	def get_answer_word
		answer = Answer.new
		answer.word
	end

	def end_game
		puts "Thanks for playing!"
		puts ""
		puts "Final scores:"
		User.all.each do |user|
			puts "#{user.name}: #{user.wins} wins, #{user.losses} losses"
		end
	end

	def check_game_over
		# probably should refactor this into 2 methods
		# If loss
		if @guesses_remaining == 0
			puts "You lost!"
			puts "The correct word was #{@answer.join}"
			@active_user.losses += 1
			@game_state = "complete"
			puts "Play again? (y/n)"
			play_again_input = gets.chomp.downcase
			if play_again_input == "y"
				Game.new
			else
				end_game
			end
		elsif
			# If win
			!@display_letters.include?("_")
			puts "You won!"
			puts "The correct word was #{@answer.join}"
			@active_user.wins += 1
			@game_state = "complete"
			puts "Play again? (y/n)"
			play_again_input = gets.chomp.downcase
			if play_again_input == "y"
				Game.new
			else
				end_game
			end
		end
	end

	def check_guess
		if @answer.include?(@user_guess)
			@answer.each_with_index do |letter, index|
				if @answer[index] == @user_guess
					@display_letters[index] = letter
				end
			end
			@correct_guess_history << @user_guess
			check_game_over
			puts "You got it!"
			print display_letters
			puts ""
		else 
			puts "Sorry try again"
			@incorrect_guess_history << @user_guess
			@guesses_remaining -= 1
			check_game_over
			puts "Try again!"
			print display_letters
			puts ""
		end
	end


end
