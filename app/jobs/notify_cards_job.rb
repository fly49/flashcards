class NotifyCardsJob < ApplicationJob
  queue_as :default

  def perform(user)
    CardsMailer.cards_notice(user).deliver_later
  end
end
