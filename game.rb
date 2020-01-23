#!/usr/bin/env ruby
class Deck
  attr_accessor :cards
  SUITS=['♤','♥','♧','♦']
  CARDS=[2,3,4,5,6,7,8,9,10,'J','Q','K','A']
  def initialize
    # Create a set of 52 cards
    # Each of 4 suits
    @cards = []
    4.times do |suit|
      # puts "Suit: #{SUITS[suit]}"
      13.times do |number|
        # puts "#{SUITS[suit]}#{CARDS[number]}"
        @cards << Card.new(suit: SUITS[suit], pi: number, name: CARDS[number])
      end
    end
  end

  def shuffle!
    @cards.shuffle!
  end

  def draw
    @cards.pop
  end
end
class Player
  attr_accessor :pile
  def initialize(name)
    @pile = []
    @name = name
  end
  def to_s
    "#{@name}"
  end
end
class Card
  attr_accessor :pi
  def initialize(suit: , pi: , name: )
    @suit = suit
    @pi   = pi
    @name = name
  end
  def to_s
    "#{@name}#{@suit}"
  end
end
class Game
  attr_reader :move_count
  attr_reader :players
  attr_accessor :log
  def initialize(p1="Bob",p2="Fred",log: true)
    @move_count = 0
    @log = log
    @players = [Player.new(p1), Player.new(p2)]
    deck = Deck.new
    deck.shuffle!
    # For each player, deal out the cards
    cplayer = 0
    deck.cards.each do |card|
      @players[cplayer].pile << card
      cplayer += 1
      cplayer = 0 if cplayer >= @players.size
    end
  end

  def step(state=[])
    @move_count += 1
    # All players lay out a card
    @players.each do |player|
      state << { player: player, card: player.pile.pop }
    end
    puts "#{state[-2][:card]} vs #{state[-1][:card]}" if log
    if state[-1][:card].pi > state[-2][:card].pi
      puts "#{state[-1][:player]} won battle" if log
      winner = state[-1][:player]
      state.shuffle.each do |entry|
        winner.pile.prepend entry[:card]
      end
    elsif state[-1][:card].pi < state[-2][:card].pi
      puts "#{state[-2][:player]} won battle" if log
      winner = state[-2][:player]
      state.shuffle.each do |entry|
        winner.pile.prepend entry[:card]
      end
    else
      # Handle the war case
      # state[0][:card].pi == state[-2][:card].pi
      puts "War: #{state[-2][:card]} vs #{state[-1][:card]}" if log
      # War returns true if game is over
      # So we return true as well
      self.war(state) and return true
    end
    if @players[0].pile.size <= 0
      puts "#{@players[1]} has won!" if log
      return true
    elsif @players[1].pile.size <= 0
      puts "#{@players[0]} has won!" if log
      return true
    end
    return false
  end

  def war(state)
    # pop 1 for face down cards
    if @players[0].pile.size <= 1
      puts "#{@players[1]} has won!" if log
      return true
    elsif @players[1].pile.size <= 1
      puts "#{@players[0]} has won!" if log
      return true
    end
    # Draw one card for each player:
    @players.each do |player|
      state << { player: player, card: player.pile.pop }
    end
    # And then step:
    self.step(state)
  end

  def play()
    while self.valid? && !self.step do
    end
  end

  def to_s
    "#{@players[0]} has #{@players[0].pile.size} cards." + "\n" +
      "#{@players[1]} has #{@players[1].pile.size} cards."
  end
  def valid?
    @players[0].pile.size > 0 && @players[1].pile.size > 0
  end
end
# Usage like: 
=begin
game = Game.new
while game.valid? do
  puts game
  game.step
end
=end
