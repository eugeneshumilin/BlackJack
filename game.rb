class Game
  include GameHelperModule
  include UserInterface

  def initialize
    greeting
    create_player
    player_greeting(current_player_name)
    create_dealer
    show_start_commands
    current_game_process
  end

  def start_game
    start_new_game
    create_hand
    starting_bank
    game_over_start_status
    place_bets
    take_cards
    play_game
    open_cards
  end
end
