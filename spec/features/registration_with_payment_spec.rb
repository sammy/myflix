require 'spec_helper'

feature 'registration with payment', js: true do

  scenario 'with valid user details and valid payment details' do
    visit register_path
    fill_in_details
    expect(page).to have_content("You have registered successfully!")
  end

  scenario 'with valid user details and invalid payment details' do
    visit register_path
    fill_in_details(card_number: '4000000000000127')
    expect(page).to have_content("Your card's security code is incorrect")
  end

  scenario 'with invalid user details and valid payment details' do
    visit register_path
    fill_in_details(email: nil)
    expect(page).to have_content("can't be blank")
  end

  scenario 'with valid user details and valid payment details but a processing error' do
    visit register_path
    fill_in_details(card_number: '4000000000000002')
    expect(page).to have_content('Your card was declined.')
  end

  def fill_in_details(card_number: '4242424242424242', email: 'someone@somewhere.com', full_name: 'Some One')
    fill_in "Email Address", with: email
    fill_in "Password", with: 'secretpass'
    fill_in "Full Name", with: full_name
    fill_in "Credit Card Number", with: card_number
    fill_in "Security Code", with: '123'
    select "6 - June", from: "date_month"
    select "2016", from: "date_year"
    click_button "Sign Up"
  end

end