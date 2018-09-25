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
      fill_in 'Password confirmation', with: user.password
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
      login(user,'abcdef')
      click_link 'Account'
      click_link 'Log out'
      expect(page).to have_content('Log in')
      expect(page).not_to have_content(user.email)
    end
  end
end