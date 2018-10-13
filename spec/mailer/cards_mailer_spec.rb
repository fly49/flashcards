require 'rails_helper'

describe CardsMailer, type: :mailer do
  describe 'welcome_email' do
    let(:user) { create(:user) }
    let(:mail) { CardsMailer.welcome_email(user).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq('Welcome to Flashcarder')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['notifications@flymyflashcards.com'])
    end
  end
  
  # Notification about expired cards
  describe 'cards_notice' do
    let(:user) { create(:user) }
    let(:mail) { CardsMailer.cards_notice(user).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq('Unchecked cards notification')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['notifications@flymyflashcards.com'])
    end
  end
end