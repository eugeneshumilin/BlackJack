class Game
  include GameHelperModule

  def initialize
    greeting
    @player = Player.new(player_name)
    player_greeting(@player.name)
    @dealer = Dealer.new
    show_start_commands
    while (choice = gets.strip)
      game_process(choice)
    end
  end

  private

  attr_accessor :game_over, :bank 

  def game_process(choice)
    if choice == 'n'
      start_game
    elsif choice == 'q'
      exit_game
    else
      puts 'Некорректный ввод.'
    end
  end

  def start_game
    start_new_game
    @hand = Hand.new
    @bank = 0
    @game_over = false
    place_bets
    take_cards
    play_game
    open_cards
  end

  def place_bets
    @bank += @player.place_bet
    @bank += @dealer.place_bet
  end

  def take_cards
    @player.receives_cards(@hand.deal_cards)
    @dealer.receives_cards(@hand.deal_cards)
  end

  def play_game
    until @game_over
      player_move
      break if @game_over || players_cards_limit?
      dealer_move
      stop_game if players_cards_limit?
    end
  end

  def player_move
    show_info
    @player.current_move(command(@player), @hand)
    @game_over = @player.opened_cards
  end

  def dealer_move
    show_info
    @dealer.current_move(@hand)
    @game_over = @dealer.opened_cards
  end

  def open_cards
    @game_over = true
    confirm
    show_info
    find_the_winner
    clear_bank
    delete_cards
    show_balances
    exit_game if players_cannot_play?
    show_start_commands
  end

  def delete_cards
    @player.clear_data
    @dealer.clear_data
  end

  def show_balances
    @player.show_bankroll
    @dealer.show_bankroll
    puts
  end

  def show_info
    @dealer.show_back_side_cards unless @game_over
    @dealer.show_face_cards if @game_over
    puts
    @player.show_face_cards
    puts
    show_score(@dealer.name, @hand.score(@dealer.cards)) if @game_over
    show_score(@player.name, @hand.score(@player.cards))

    show_bank(@bank)
  end

  def stop_game
    show_info
    self.game_over = true
  end

  def find_the_winner
    player_score = @hand.score(@player.cards)
    dealer_score = @hand.score(@dealer.cards)
    if @hand.draw?(player_score, dealer_score)
      drawn_game
      players_take_a_bank(@bank / 2.0)
    elsif @hand.player_win?(player_score, dealer_score)
      @player.take_bank(@bank)
    else
      @dealer.take_bank(@bank)
    end
  end

  def players_take_a_bank(amount)
    @dealer.take_bank(amount)
    @player.take_bank(amount)
  end

  def clear_bank
    @bank = 0
  end

  def players_cards_limit?
    @player.cards.size == 3 && @dealer.cards.size == 3
  end

  def players_cannot_play?
    @player.bankroll.zero? || @dealer.bankroll.zero?
  end
end
