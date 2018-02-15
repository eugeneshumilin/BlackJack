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

  def game_process(choice)
    if choice == GameHelperModule::CHOICES[:new]
      start_game
    elsif choice == GameHelperModule::CHOICES[:quit]
      exit_game
    else
      puts 'Некорректный ввод.'
    end
  end

  def current_game_process
    while (choice = gets.strip)
      game_process(choice)
    end
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

  def player_name
    print 'Введите свое имя:'
    name = gets.strip
    raise unless name != ''
    name
  rescue RuntimeError
    puts 'Name cannot be blank.'
    retry
  end

  def command(user)
    ask_user_choice(user)
    choice = gets.strip
    exit_game if choice == GameHelperModule::CHOICES[:quit]
    raise unless %w[s t o].include?(choice)
    choice
  rescue RuntimeError
    puts 'Command is invalid.'
    retry
  end

  def ask_user_choice(user)
    puts 'Выберите выш следующий шаг'
    puts "Введите 's' для пропуска хода." unless user.skipped_move
    puts "Введите 't' чтобы взять одну карту." if user.can_take_cards?
    puts "Введите 'o' чтобы открыть карты."
    puts "Введите 'q' чтобы выйти."
  end

  def confirm
    puts 'Нажмите любую кнопку, чтобы подтвердить действие...'
    gets
  end

  def greeting
    puts 'Добро пожаловать в BlackJack!'
  end

  def player_greeting(name)
    puts "Привет, #{name}!"
  end

  def exit_game
    puts 'Игра окончена!'
    exit
  end

  def start_new_game
    puts 'Начинаем новую игру'
  end

  def drawn_game
    puts 'Ничья.'
  end

  def show_start_commands
    puts "Введите 'n' для начала новой игры."
    puts "Введите 'q' для выхода."
  end

  def show_score(name, score)
    puts "#{name}'s scores: #{score}"
  end

  def show_bank(bank)
    puts "Bank: #{bank}"
  end
end
