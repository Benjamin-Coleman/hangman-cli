require 'pry'
require 'highline'

require_relative 'Answer'
require_relative 'User'
require_relative 'Art'

class Game
	attr_accessor :answer, :display_letters
                          
	def initialize
		@answer = get_answer_word.split("")
		@display_letters = Array.new(@answer.length){"_"}
		@guesses_remaining = 7
		@incorrect_guess_history = []
		@correct_guess_history = []
		@user_guess = ""
		@game_state = "in progress"
		@multiplayer_game = false
		system 'clear'
		puts "#{Art.hangman_header}"
		puts "What's your name"
		@active_user = ""
		@user_name = gets.chomp
		@active_user = User.find_or_create_by_name(@user_name)
		multiplayer?
		show_ui
		until @game_state == "complete"
			play
		end
	end

	def multiplayer?
		puts "1 - Versus computer"
		puts "2 - Versus player"
		cpu_or_player = gets.chomp
			if cpu_or_player == "2"
				@multiplayer_game = true
				define_word
			elsif cpu_or_player != "1"
				puts "Please enter '1' or '2'"
				multiplayer?
			end

	end

	def play
		input_guess
		validate_guess
		check_guess
	end

	def define_word
		cli = HighLine.new
		chosen_word = cli.ask("#{@active_user.name} please enter your word to be guessed:      ") { |q| q.echo = "*" }
		@display_letters = Array.new(chosen_word.length){"_"}
		@answer = chosen_word.split("")
	end

	def input_guess
		if @multiplayer_game
			puts "Player 2"
		end
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
		if @user_guess == "quit" || @user_guess == "exit"
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

	def play_again?
		puts "Play again? (y/n)"
		play_again_input = gets.chomp.downcase
		if play_again_input == "y"
			Game.new
		else
			end_game
		end
	end

	def lost_game
			puts "You lost!".colorize(:red)
			Art.guesses_remaining_0
			puts "The correct word was #{@answer.join}"
			@active_user.losses += 1
			@game_state = "complete"
			play_again?
	end

	def won_game
		puts "You won!".colorize(:green)
		puts "The correct word was #{@answer.join}"
		@active_user.wins += 1
		@game_state = "complete"
		play_again?
	end

	def check_game_over
		if @guesses_remaining == 0
			lost_game
		elsif !@display_letters.include?("_")
			won_game
		end
	end

	def show_ui
		Art.send("guesses_remaining_#{@guesses_remaining}")
		print "\n#{display_letters.join(" ")}\n\n"
		puts "Guessed letters: #{@incorrect_guess_history + @correct_guess_history} \n\n"
	end

	def correct_guess
		system 'clear'
		@answer.each_with_index do |letter, index|
			if @answer[index] == @user_guess
				@display_letters[index] = letter
			end
		end
		@correct_guess_history << @user_guess
		check_game_over
		Art.send("guesses_remaining_#{@guesses_remaining}")
		puts "You got it!".colorize(:green)
		print "\n#{display_letters.join(" ")}\n\n"
		puts "Guessed letters: #{@incorrect_guess_history + @correct_guess_history} \n\n"
	end

	def incorrect_guess
		system 'clear'
		@incorrect_guess_history << @user_guess
		@guesses_remaining -= 1
		check_game_over
		Art.send("guesses_remaining_#{@guesses_remaining}")
		puts "Sorry try again".colorize(:red)
		print "\n#{display_letters.join(" ")}\n\n"
		puts "Guessed letters: #{@incorrect_guess_history + @correct_guess_history} \n\n"
	end

	def check_guess
		if @answer.include?(@user_guess)
			correct_guess
		else 
			incorrect_guess
		end
	end


end
