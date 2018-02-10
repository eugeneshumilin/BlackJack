class Deck
  SUITS = %w[♡ ♧ ♢ ♤].freeze
  VALUES = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze

  attr_reader :deck

  def initialize
    @deck = create_deck
  end

  private

  def create_deck
    @deck = []
    VALUES.each do |value|
      SUITS.each do |suit|
        @deck << Card.new(suit, value)
      end
    end
    @deck.shuffle
  end
end
