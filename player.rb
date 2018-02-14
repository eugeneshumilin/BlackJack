class Player < User
  def current_move(choice, hand)
    if can_skip?(choice)
      skip_move
    elsif can_take_card?(choice)
      recieves_one_card(hand.deal_one_card)
    elsif can_open_cards?(choice)
      open_cards
    end
  end

  private

  def can_skip?(choice)
    choice == GameHelperModule::CHOICES[:skip] && !@skipped_move
  end

  def can_take_card?(choice)
    choice == GameHelperModule::CHOICES[:take] && !@took_a_card
  end

  def can_open_cards?(choise)
    choise == GameHelperModule::CHOICES[:open]
  end
end
