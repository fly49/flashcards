# frozen_string_literal: true

require 'rails_helper'

feature 'user can change his email and password' do
  let(:user) { create(:user, password: 'abcdef') }

  scenario 'user change account settings successfully' do
    log_in(user,'abcdef')
    click_link 'Account'
    click_link 'Settings'
    fill_in 'Email', with: 'new@mail.com'
    fill_in 'Password', with: 'new_password'
    fill_in 'Confirm your password', with: 'new_password'
    click_button 'Update User'
    expect(page).to have_content(I18n.t('user.flashes.successfull.update'))
    expect(page).to have_content('new@mail.com')
  end
  
  scenario 'user change account language successfully' do
    log_in(user,'abcdef')
    click_link 'Account'
    click_link 'Settings'
    select 'ru', from: 'Language'
    click_button 'Update User'
    expect(page).to have_content('Добро пожаловать во Flashcarder')
  end
end
