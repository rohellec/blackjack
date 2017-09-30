class Deck
  FACES = [
    "2", "3", "4", "5", "6", "7", "8",
    "9", "10", "J", "Q", "K", "A"
  ]
  SUITS = ["\u2660", "\u2661", "\u2662", "\u2663"]

  attr_reader :cards

  def self.default
    Deck.new.cards.freeze
  end

  def initialize
    @cards = []
    FACES.each do |face|
      SUITS.each { |suit| @cards << Card.new(face, suit) }
    end
  end

  def get_card
    card_num = rand(cards.length)
    cards.delete_at(card_num)
  end
end

