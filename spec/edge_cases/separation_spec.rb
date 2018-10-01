# frozen_string_literal: true

require 'rails_helper'

feature 'users control actions should not interfere' do
  let!(:user) { create(:user, password: 'password') }
  let!(:another_user) { create(:user, password: 'another_password') }
  
  context 'users should not have access to the cards of each other' do
    let(:card) { create(:card, user_id: user.id) }

    scenario "another user hasn't access to the card" do
      log_in(user,'password')
      card
      log_out
      log_in(another_user,'another_password')
      visit card_path(card)
      expect(current_path).to eq '/'
    end
  end
  
  context 'users should not have access to the decks of each other' do
    let(:deck) { create(:deck, user_id: user.id) }
    
    scenario "another user hasn't access to the deck" do
      log_in(user,'password')
      deck
      log_out
      log_in(another_user,'another_password')
      visit deck_path(deck)
      expect(current_path).to eq '/'
    end
  end
end
