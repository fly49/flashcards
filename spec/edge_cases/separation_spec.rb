# frozen_string_literal: true

require 'rails_helper'

feature 'users control actions should not interfere' do
  let!(:user) { create(:user, password: 'password') }
  let!(:another_user) { create(:user, password: 'another_password') }
  
  context 'users should not have access to the cards of each other' do
    let(:card) { create(:card, user: user) }

    scenario "another user hasn't access to the card" do
      log_in(user,'password')
      card
      log_out
      log_in(another_user,'another_password')
      expect{ visit card_path(card) }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end
  
  context 'users should not have access to the decks of each other' do
    let(:deck) { create(:deck, user: user) }
    
    scenario "another user hasn't access to the deck" do
      log_in(user,'password')
      deck
      log_out
      log_in(another_user,'another_password')
      expect{ visit deck_path(deck) }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end
end
