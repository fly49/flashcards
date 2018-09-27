# frozen_string_literal: true

require 'rails_helper'

feature 'user can attach image to a card' do
  let(:user) { create(:user, password: 'abcdef') }
    let(:card) { create(:card, user_id: user.id) }

    before(:each) do
      log_in(user,'abcdef')
      card
      click_link 'Cards'
      click_link 'All Cards'
      find("a[href='#{card_path(card)}']").click
      click_button 'Edit'
    end

  scenario 'user attaches image successfully' do
    attach_file("card_image", Rails.root + "spec/fixtures/fuji.jpg")
    click_button 'Update Card'
    expect(page).to have_content(I18n.t('card.flashes.successfull.update'))
    expect(page).to have_xpath("//img[contains(@src, \"https:\/\/flymypiecardimagebucket.s3.amazonaws.com\")]")
  end
  
  scenario 'user deletes image successfully' do
    attach_file("card_image", Rails.root + "spec/fixtures/fuji.jpg")
    click_button 'Update Card'
    find("a[href='#{card_path(card)}']").click
    click_button 'Edit'
    find(:css, "#card_remove_image").set(true)
    click_button 'Update Card'
    expect(page).not_to have_xpath("//img[contains(@src, \"https:\/\/flymypiecardimagebucket.s3.amazonaws.com\")]")
  end
end
