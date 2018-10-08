class CardsMailer < ActionMailer::Base
  default from: 'notifications@flymyflashcards.com'

  def welcome_email
    @user = params[:user]
    @url  = 'https://flymyflashcards.herokuapp.com/'
    mail(to: @user.email, subject: 'Welcome to Flashcarder')
  end
  
  def cards_notice
    @user = params[:user]
    @cards_count = @user.cards.ready.count
    @url  = 'https://flymyflashcards.herokuapp.com/'
    mail(to: @user.email, subject: 'Unchecked cards notification')
  end
end
