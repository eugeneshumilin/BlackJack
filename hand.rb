class Hand
  FACE_VALUE = 10
  ACE_ONE_VALUE = 1
  WIN_SCORE = 21

  def initialize
    @cards = Deck.new.deck
  end

  def deal_cards(count = 2)
    @cards.sample(count).each { |value| @cards.delete(value) }
  end

  def deal_one_card
    deal_cards(1)
  end

  def score(cards)
    total_score = 0
    cards.each do |card|
      total_score += get_card_price(card)
      total_score += 10 if card.value == 'A' && total_score < 12
    end
    total_score
  end

  def draw?(player_score, dealer_score)
    player_score == dealer_score
  end

  def player_win?(player_score, dealer_score)
    win_score?(player_score) || player_less_difference?(player_score, dealer_score)
  end

  def player_less_difference?(player_score, dealer_score)
    score_difference(player_score) < score_difference(dealer_score)
  end

  private

  def get_card_price(card)
    if %w[J Q K].include? card.value
      FACE_VALUE
    elsif card.value == 'A'
      ACE_ONE_VALUE
    else
      card.value.to_i
    end
  end

  def win_score?(score)
    score == FACE_VALUE
  end

  def score_difference(score)
    (WIN_SCORE - score).abs
  end
end
