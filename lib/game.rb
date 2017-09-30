require_relative "card"
require_relative "deck"
require_relative "player"

class Game
  def initialize
    @deck = Deck.new
    @dealer = Player.new("dealer", BANK_SIZE)
  end

  def run
    system("clear")
    puts  "Welcome to Black Jack!"
    print "Please, enter the name of the player: "
    name = gets.chomp
    @player = Player.new(name, BANK_SIZE)
    start_game
  end

  private

  ACTIONS = {
    1 => :pass,
    2 => :take_card,
    3 => :open_cards
  }

  PROMPT = <<~SUMMARY
    Player's turn:
    1. Pass
    2. Take card
    3. Open cards
  SUMMARY

  BANK_SIZE = 100
  MAX_CARDS_AMOUNT = 3
  GAME_RATE_AMOUNT = 10
  VICTORY_POINTS = 21

  def deal_cards
    2.times do
      @player.hand << @deck.get_card
      @dealer.hand << @deck.get_card
    end
  end

  def dealer_action
    @dealer.take_card(@deck.get_card) if @dealer.take_card?
  end

  def dealer_info(points: false)
    puts "========DEALER========="
    if points
      @dealer.display_hand
      puts "Points: #{@dealer.points}"
    else
      print "Dealer's hand: "
      @dealer.hand.length.times { print "*" }
      puts
    end
  end

  def end_game
    if @player.points <= VICTORY_POINTS &&
      (@player.points >  @dealer.points ||
       @dealer.points >  VICTORY_POINTS)
      puts "#{@player} has won"
      transfer_amount(@dealer, @player)
    else
      puts "Dealer has won"
      transfer_amount(@player, @dealer)
    end
  end

  def fill_bank
    @player.balance -= GAME_RATE_AMOUNT
    @dealer.balance -= GAME_RATE_AMOUNT
  end

  def game_active?
    @player.balance >= GAME_RATE_AMOUNT &&
    @dealer.balance >= GAME_RATE_AMOUNT
  end

  def game_info(dealer_points: false)
    system("clear")
    player_info
    dealer_info(points: dealer_points)
    puts "**********************"
  end

  def new_game
    @dealer.clear_hand
    @player.clear_hand
    deal_cards
    fill_bank
    @turn_finished = false
    start_turn while next_turn?
    unless @turn_finished
      game_info(dealer_points: true)
      end_game
    end
  end

  def next_turn?
    (@player.hand.size != MAX_CARDS_AMOUNT  ||
     @dealer.hand.size != MAX_CARDS_AMOUNT) &&
    !@turn_finished
  end

  def open_cards
    @turn_finished = true
    game_info(dealer_points: true)
    end_game
  end

  def pass
  end

  def player_action
    puts PROMPT
    input = gets.to_i
    action = ACTIONS.fetch(input)
    send(action)
  rescue KeyError
    wrong_input
    retry
  end

  def player_info
    puts "========PLAYER========"
    @player.display_hand
    puts "Points: #{@player.points}"
  end

  def start_game
    loop do
      new_game
      if game_active?
        puts "Do you want to play one more time? (Y/n)"
        input = gets.chomp.downcase
        break unless input.empty? || input == "y"
      end
    end
  end

  def start_turn
    game_info
    player_action
    dealer_action unless @turn_finished
  end

  def take_card
    @player.take_card(@deck.get_card)
  end

  def transfer_amount(credit, debit)
    credit.balance -= GAME_RATE_AMOUNT
    debit.balance  += GAME_RATE_AMOUNT
  end

  def wrong_input
    system("clear")
    puts "Wrong input! Please, try again."
  end
end
