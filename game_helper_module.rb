module GameHelperModule
  CHOICES = { quit: 'q', skip: 's', take: 't', open: 'o', new: 'n' }.freeze

  private

  attr_accessor :game_over, :bank

  def create_player
    @player = Player.new(player_name)
  end

  def create_dealer
    @dealer = Dealer.new
  end

  def current_player_name
    @player.name
  end

  def starting_bank
    @bank = 0
  end

  def game_over_start_status
    @game_over = false
  end

  def create_hand
    @hand = Hand.new
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

  def stop_game
    show_info
    @game_over = true
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
