#!/usr/bin/env ruby
require './game'
def checkargs
	ARGV.size == 1 && ARGV[0].to_i != 0
end
(puts("Usage: ww3 <count>"); exit(1)) unless checkargs
game_total = 0
move_total = 0
count = ARGV[0].to_i
count.times do
	game = Game.new(log: false)
	game.play
	move_total += game.move_count
	game_total += 1
end
puts "Average: %d" % (move_total / game_total)
