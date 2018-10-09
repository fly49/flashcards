class SendWelcomeJob < ApplicationJob
  queue_as :default

  def perform(user)
    CardsMailer.welcome_email(user).deliver_later
  end
end
