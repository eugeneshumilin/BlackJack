class User
  BET_PRICE = 10
  START_BANKROLL = 100
  MAX_COUNT_OF_CARDS = 3

  attr_reader :name, :bankroll, :cards, :skipped_move, :took_a_card, :opened_cards

  def initialize(name)
    @name = name
    @bankroll = START_BANKROLL
    @cards = []
    @skipped_move = false
    @took_a_card = false
    @opened_cards = false
  end

  def place_bet
    @bankroll -= BET_PRICE
    BET_PRICE
  end

  def take_bank(money)
    @bankroll += money
  end

  def receives_cards(cards)
    @cards + cards if can_take_cards?
  end

  def show_face_cards
    @cards.each { |card| print "|#{card.value}#{card.suit}| " }
  end

  def show_back_side_cards
    @cards.size.times { print '* ' }
  end

  def show_bankroll
    puts "#{name}'s bankroll: #{@bankroll}"
  end

  def clear_data
    @cards = []
    @skipped_move = false
    @took_a_card = false
    @opened_cards = false
  end

  def win(bank)
    puts "#{name} победил!"
    take_bank(bank)
  end

  protected

  attr_writer :skipped_move, :took_a_card, :opened_cards

  def can_take_cards?
    @cards.size < MAX_COUNT_OF_CARDS
  end

  def skip_move
    puts "#{name} пропускает ход."
    @skipped_move = true
  end

  def recieves_one_card(card)
    puts "#{name} берет одну карту."
    receives_cards(card)
    @took_a_card = true
  end

  def open_cards
    puts "#{name} хочет открыть карты."
    @opened_cards = true
  end
end
