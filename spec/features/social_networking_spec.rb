require 'spec_helper'

feature 'Social Networking' do

  given(:greg) { Fabricate(:user) }
  given(:felix) { Fabricate(:user, full_name: "Felix Thecat") }

  scenario 'Login, view user profile, follow user and unfollow user' do
    action_movies = Fabricate(:category, name: 'Action')
    the_hunt = Fabricate(:video, title: 'The Hunt', description: 'A description', category: action_movies)
    review = Fabricate(:review, user: felix, video: the_hunt )
    
    sign_in(greg)
    click_link('TheHunt')
    expect(page).to have_content 'Felix Thecat'

    find_link("Felix Thecat").click
    expect(page).to have_content 'Follow'

    click_link('Follow')
    expect(page).to have_content('People I Follow')
    expect(page).to have_content('You are now following Felix Thecat')

    click_link("unfollow_FelixThecat")
    expect(page).to have_content('People I Follow')
    expect(page).to_not have_content('Felix Thecat')
  end
end