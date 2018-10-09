class CardsMailer < ApplicationMailer
  
  def welcome_email(user)
    @url  = Settings.application_url
    mail(to: user.email, subject: I18n.t('mailer.welcome.subject'))
  end
  
  def cards_notice(user)
    @cards_count = user.cards.ready.count
    @url  = Settings.application_url
    mail(to: user.email, subject: I18n.t('mailer.cards_notice.subject'))
  end
end
