require 'spec_helper'

feature 'User invites friend' do

  scenario 'user invites friend', :vcr do
    bob = Fabricate(:user, email: 'bob@bob.com')
    sign_in(bob)

    user_invites_friend(bob)
    sign_out(bob)
    binding.pry
    friend_accepts_invitation
    jane = User.find_by(email: 'jane.something@home.com')
    jane.password = 'mypassword'    
    sign_in(jane)
    friend_follows_user(bob)
    sign_out(jane)
    sign_in(bob)
    user_follows_friend        
    clear_email
  end

  def user_invites_friend(user)
    click_link("Welcome, #{user.full_name}")
    click_link("Invite a friend")
    expect(page).to have_content('Invite a friend to join MyFlix!')
    fill_in "invitation_recipient_name", with: 'Jane Something'
    fill_in "invitation_recipient_email", with: 'jane.something@home.com'
    fill_in "invitation_message", with: "Join this nice website"
    click_button 'Send Invitation'
  end

  def friend_accepts_invitation
    open_email('jane.something@home.com')
    current_email.click_link('Take me to Myflix!')
    expect(page).to have_content('Register')
    find_field('user_email').value.should eq('jane.something@home.com')
    find_field('user_full_name').value.should eq('Jane Something')
    fill_in 'user_password', with: 'mypassword'
    fill_in 'Credit Card Number', with: '4242424242424242'
    fill_in 'Security Code', with: '666'
    select '12 - December', :from => 'date_month'
    select '2017', :from => 'date_year'
    click_button 'Sign Up'
    expect(open_email('jane.something@home.com')).to have_content('Jane Something, you have been invited to Myflix')
  end

  def user_follows_friend
    click_link "People"
    expect(page).to have_content('Jane Something')
  end

  def friend_follows_user(user)
    click_link "People"    
    expect(page).to have_content(user.full_name)
  end
end