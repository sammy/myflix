require 'spec_helper'

feature 'Signing in' do 
  
  background do
    User.create(email: 'someone@myflix.com', password: 'Password123', full_name: 'Some User')
  end

  scenario 'Signing in with correct credentials' do
    visit sign_in_path
    fill_in "email", with: 'someone@myflix.com'
    fill_in "password", with: 'Password123'
    click_button 'Sign in'
    expect(page).to have_content 'Welcome, Some User'
  end

  scenario 'Signing in with incorrect credentials' do
    visit sign_in_path
    fill_in 'email', with: 'someone@flix.com'
    fill_in 'password', with: 'wrongpassword'
    click_button 'Sign in'
    expect(page).to have_content 'Incorrect username or password'
  end
  
end