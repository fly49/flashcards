# frozen_string_literal: true

require 'rails_helper'

feature 'Check card' do
  context 'check random card' do
    let!(:card) { create(:card, :old) }
    before(:each) { visit root_path }

    scenario 'card should be checked successfully' do
      within('form') do
        fill_in 'Translation', with: card.original_text
      end
      click_button 'Check'
      expect(page).to have_content(I18n.t('card.flashes.successfull.check'))
    end

    scenario "card shouldn't been checked" do
      within('form') do
        fill_in 'Translation', with: 'abracadabra'
      end
      click_button 'Check'
      expect(page).to have_content(I18n.t('card.flashes.unsuccessfull.check'))
    end
  end
end
