# frozen_string_literal: true

require 'rails_helper'

feature 'users control actions should not interfere' do
  context 'users should not have access to the cards each other' do
    let(:user) { create(:user, password: 'abcdef') }
    let(:another_user) { create(:user, password: 'abcdef') }
    let(:card) { create(:card, user_id: user.id) }

    scenario "another user hasn't access to the card" do
      log_in(user,'abcdef')
      card
      log_out
      log_in(another_user,'abcdef')
      visit card_path(card)
      expect(current_path).to eq '/'
    end
  end
end