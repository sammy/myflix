require 'spec_helper'

feature 'Admin sees payments' do

  scenario 'Admin can see payments' do
    payment = Fabricate(:payment)
    user = Fabricate(:user, is_admin: true)
    visit sign_in_path
    sign_in(user)
    visit admin_payments_path
    expect(page).to have_content("Recent Payments")
    expect(page).to have_content(payment.user_email)
    expect(page).to have_content(payment.user_full_name)
    expect(page).to have_content(payment.amount_to_decimal)
  end

  scenario 'User cannot see payments' do
    payment = Fabricate(:payment)
    user = Fabricate(:user, is_admin: false)
    visit sign_in_path
    sign_in(user)
    visit admin_payments_path
    expect(page).to have_content("Not authorized!")
  end
end