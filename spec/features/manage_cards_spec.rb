# frozen_string_literal: true

require 'rails_helper'

feature 'manage cards' do
  context 'add card' do
    let(:user) { create(:user, password: 'abcdef') }

    scenario 'card successfully added' do
      log_in(user,'abcdef')
      click_link 'Cards'
      click_link 'Add Card'
      fill_in 'Original text', with: 'word'
      fill_in 'Translated text', with: 'translation'
      page.check('Basic')
      click_button 'Create Card'
      expect(page).to have_content(I18n.t('card.flashes.successfull.create'))
      click_link 'Cards'
      click_link 'All Cards'
      expect(page).to have_content('word').and have_content('translation')
    end
  end

  context 'check card' do
    let(:user) { create(:user, password: 'abcdef') }
    let(:card) { create(:card, :old, user_id: user.id) }
    before(:each) do
      log_in(user,'abcdef')
      card
      visit root_path
    end

    scenario 'card should be checked successfully' do
      fill_in 'Translation', with: card.original_text
      click_button 'Check'
      expect(page).to have_content(I18n.t('card.flashes.successfull.check'))
      expect(page).to have_content('All cards have been viewed')
    end

    scenario "card shouldn't been checked" do
      within('form') do
        fill_in 'Translation', with: 'abracadabra'
      end
      click_button 'Check'
      expect(page).to have_content(I18n.t('card.flashes.unsuccessfull.check'))
    end
  end

  context 'manage specific card' do
    let(:user) { create(:user, password: 'abcdef') }
    let(:card) { create(:card, user_id: user.id) }

    before(:each) do
      log_in(user,'abcdef')
      card
      click_link 'Cards'
      click_link 'All Cards'
      find("a[href='#{card_path(card)}']").click
    end

    context 'show card' do
      scenario 'card was successfully shown' do
        expect(page).to have_content(card.original_text).and have_content(card.translated_text)
      end
    end

    context 'edit card' do
      scenario 'card was successfully edited' do
        click_button 'Edit'
        fill_in 'Original text', with: 'word'
        fill_in 'Translated text', with: 'translation'
        click_button 'Update Card'
        expect(page).to have_content('word').and have_content('translation')
      end
    end

    context 'delete card' do
      scenario 'card was successfully deleted' do
        click_button 'Delete'
        expect(page).not_to have_content(card.original_text)
      end
    end
  end
end
