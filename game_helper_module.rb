module GameHelperModule
  CHOICES = { quit: 'q', skip: 's', take: 't', open: 'o', new: 'n' }.freeze

  private

  def player_name
    puts 'Введите свое имя:'
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
