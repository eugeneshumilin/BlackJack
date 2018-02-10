class User
  attr_reader :name, :bankroll, :hand, :points

  def initialize(name)
    @name = name
    @bankroll = 100
    @hand = []
    @points = 0
  end

  def take_a_card
    # something
  end

  def miss_turn
    # something
  end

  def open_cards
    # something
  end
end
