#!/usr/bin/env ruby

require_relative '../config/environment'

class Runner
	def run
		Game.new
	end
end

runner = Runner.new
runner.run
