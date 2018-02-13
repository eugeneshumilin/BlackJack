class Dealer < User
  SKIP_SCORE = 17

  def initialize(name = 'dealer')
    super(name)
  end

  def current_move(hand)
    think
    if can_skip?(hand.score(@cards))
      skip_move
    elsif can_take_card?
      recieves_one_card(hand.one_card)
    else
      open_cards
    end
  end

  private

  def think
    puts "#{name} сейчас думает над своим ходом..."
    sleep(2)
  end

  def can_skip?(score)
    score >= SKIP_SCORE && !@skipped_move
  end

  def can_take_card?
    !@took_a_card
  end
end
