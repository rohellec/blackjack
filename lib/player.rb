require_relative "deck"

class Player
  VICTORY_POINTS = 21

  attr_accessor :balance
  attr_reader :name, :hand

  def initialize(name, balance)
    @name = name
    @balance = balance
    @hand = []
  end

  def clear_hand
    @hand = []
  end

  def display_hand
    puts "#{name}'s hand: #{hand.join(' ')}"
  end

  def points
    sum = 0
    hand.sort.each do |card|
      sum += card.value_for(sum)
    end
    sum
  end

  def take_card(card)
    hand << card
  end

  def take_card?
    success_probability >= 0.5
  end

  def to_s
    name.to_s
  end

  private

  def success_probability
    success_cards = 0
    (Deck.default - hand).each do |card|
      value = card.value_for(points)
      success_cards += 1 if value <= VICTORY_POINTS - points
    end
    success_cards.to_f / Deck.default.size
  end
end
