#!/usr/bin/env ruby
require './game'
(puts("Usage: war <p1> <p2>"); exit(1)) unless ARGV.size == 2
game = Game.new(ARGV[0], ARGV[1])
while game.valid? do
  puts game
  game.step
end
#puts "#{game.players[0]} has #{game.players[0].pile.size} cards"
#puts "#{game.players[1]} has #{game.players[1].pile.size} cards"
#puts "There have been #{game.move_count} battles"
