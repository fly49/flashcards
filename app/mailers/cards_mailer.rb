class CardsMailer < ApplicationMailer
  default from: DEFAULT_ADRESS

  def welcome_email
    @user = params[:user]
    @url  = DEFAULT_URL
    mail(to: @user.email, subject: 'Welcome to Flashcarder')
  end
  
  def cards_notice
    @user = params[:user]
    @cards_count = @user.cards.ready.count
    @url  = DEFAULT_URL
    mail(to: @user.email, subject: 'Unchecked cards notification')
  end
end
