# frozen_string_literal: true

require 'rails_helper'

feature 'manage decks' do
  let(:user) { create(:user, password: 'abcdef') }
  
  before(:each) do
    log_in(user,'abcdef')
  end
  
  context 'create deck' do
    scenario 'deck was successfully created' do
      click_link 'Decks'
      click_link 'Create Deck'
      fill_in 'Name', with: 'deck_name'
      click_button 'Create Deck'
      expect(page).to have_content(I18n.t('deck.flashes.successfull.create'))
      click_link 'Decks'
      click_link 'All Decks'
      expect(page).to have_content('deck_name')
      click_link 'Cards'
      click_link 'Add Card'
      expect(page).to have_content('deck_name')
    end
  end
  
  context 'delete deck' do
    scenario 'deck was successfully deleted' do
      click_link 'Decks'
      click_link 'Create Deck'
      fill_in 'Name', with: 'deck_name'
      click_button 'Create Deck'
      click_button 'Delete'
      expect(page).to have_content(I18n.t('deck.flashes.successfull.destroy'))
      expect(page).not_to have_content('deck_name')
      click_link 'Cards'
      click_link 'Add Card'
      expect(page).not_to have_content('deck_name')
    end
  end
  
  context 'current deck on main page' do
    scenario 'cards from current decks was successfully shown' do
      click_link 'Decks'
      click_link 'Create Deck'
      fill_in 'Name', with: 'Advanced'
      click_button 'Create Deck'
      click_link 'Cards'
      click_link 'Add Card'
      fill_in 'Original text', with: 'card_from_basic_deck'
      fill_in 'Translated text', with: 'card_from_basic_deck_translation'
      page.check('Basic')
      click_button 'Create Card'
      fill_in 'Original text', with: 'card_from_advanced_deck'
      fill_in 'Translated text', with: 'card_from_advanced_deck_translation'
      page.check('Advanced')
      click_button 'Create Card'
      Timecop.freeze(Date.today + 3) do
        visit root_url
        expect(page).to have_content('card_from_basic_deck_translation')
        click_link 'Decks'
        click_link 'All Decks'
        click_button 'Make Current'
        visit root_url
        expect(page).to have_content('card_from_advanced_deck_translation')
      end
    end
  end
end