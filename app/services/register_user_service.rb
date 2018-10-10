class RegisterUserService
  class << self
    def register_user(user, locale)
      user.settings = { locale: locale }
      false unless user.save
      user.add_basic_deck
      CardsMailer.welcome_email(user).deliver_later
      true
    end
  end
end
