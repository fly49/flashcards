# frozen_string_literal: true

require 'rails_helper'

feature 'Authentication' do
  before(:each) { visit root_path }
  
  context 'sign up' do
    let(:user) { build(:user) }

    scenario 'successfull sign up' do
      click_link 'Sign up now!'
      expect(page).to have_content('Sign up')
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      fill_in 'Confirm your password', with: user.password
      click_button 'Create my account'
      expect(page).to have_content(I18n.t('user.flashes.successfull.create'))
      expect(page).to have_content(user.email)
    end
  end

  context 'log in' do
    let!(:user) { create(:user, password: 'abcdef') }

    scenario 'successfull log in' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'abcdef'
      click_button 'Log In'
      expect(page).to have_content(I18n.t('session.flashes.successfull.create'))
      expect(page).to have_content(user.email)
    end
  end

  context 'log out' do
    let(:user) { create(:user, password: 'abcdef') }

    scenario 'successfull log in' do
      log_in(user,'abcdef')
      click_link 'Account'
      click_link 'Log out'
      expect(page).to have_selector(:link_or_button, 'Log In')
      expect(page).not_to have_content(user.email)
    end
  end
  
  context 'change language' do
    let(:user) { build(:user) }

    scenario 'successfull language change' do
      click_link 'Russian'
      expect(page).to have_content('Добро пожаловать во Флешкардер!')
    end
  end
end