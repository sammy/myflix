require 'spec_helper'

feature 'Signing in' do 
  
  given(:user) {User.create(email: 'someone@myflix.com', password: 'Password123', full_name: 'Some User')}
  given(:inactive_user) { User.create(email: 'sometwo@myflix.com', password: 'Password123', full_name: 'Some User', is_locked: true)}

  scenario 'Signing in with correct credentials' do
    sign_in(user)
    expect(page).to have_content 'Welcome, Some User'
  end

  scenario 'Signing in with incorrect credentials' do
    visit sign_in_path
    fill_in 'email', with: 'someone@flix.com'
    fill_in 'password', with: 'wrongpassword'
    click_button 'Sign in'
    expect(page).to have_content 'Incorrect username or password' 
  end
  
  scenario 'Sign in attempt with deactivated user' do
    sign_in(inactive_user)
    expect(page).to have_content("Your account has been locked. Please contact support@myflix.com.")
  end  
end