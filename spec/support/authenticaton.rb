module AuthenticationForFeatureRequest
  def log_in(user,password)
    visit root_url
    fill_in 'Email', with: user.email
    fill_in 'Password', with: password
    click_button 'Log In'
  end

  def log_out
    click_link 'Account'
    click_link 'Log out'
  end
end
