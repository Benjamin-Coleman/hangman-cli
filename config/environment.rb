require "pry"
require "bundler/setup"
# require 'yaml'
# require 'active_record'

Bundler.require

# require_relative './console.rb'
require_relative '../app/models/Answer.rb'
require_relative '../app/models/Game.rb'

Pry.start

# The config folder should have your environment file, which should require 
# all the other files that are needed to run your project, and load Bundler to require all of the dependencies listed in your Gemfile