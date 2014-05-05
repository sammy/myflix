require 'spec_helper'

feature 'Reset user password' do
  
  scenario 'Reset password' do
    john = Fabricate(:user, email: 'john@example.com')
    visit sign_in_path
    find_link('Forgot Password').click
    fill_in "email", with: 'john@example.com'
    click_button 'Send Email'
    expect(page).to have_content('We have send an email with instruction to reset your password.')

    open_email('john@example.com')
    current_email.click_link('reset_password')
    expect(page).to have_content('Reset Your Password')
    fill_in "password", with: 'my_new_password'
    click_button 'Reset Password'
    expect(page).to have_content('Succesfully reset password')

    fill_in "email", with: 'john@example.com'
    fill_in "password", with: 'my_new_password'
    click_button 'Sign in'
    expect(page).to have_content('You have logged in')
    expect(page).to have_content("Welcome, #{john.full_name}")

    clear_email
  end
end