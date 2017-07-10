require 'pry'

class User
	attr_accessor :name, :score, :wins, :losses, :all

	@@all = []

	@@all_names = []

	def initialize(name)
		@name = name
		@wins = 0
		@losses = 0
		@@all << self
		@@all_names << name.downcase
	end

	def self.find_or_create_by_name(name)
		@@all.each do |user|
			if name == user.name
				puts "Welcome back #{name}"
				puts "You have #{user.wins} wins and #{user.losses} losses."
				return user
			end
		end
		puts "Welcome #{name}!"
		User.new(name)
	end

	def self.all
		@@all
	end

	def self.all_names
		@@all_names
	end

	def add_loss
		@loss += 1
	end

	def add_win
		@wins += 1
	end

	def score
		puts "#{@name}, you have #{@wins} wins and #{@losses} losses."
	end

end