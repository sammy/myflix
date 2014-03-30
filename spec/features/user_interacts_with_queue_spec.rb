require 'spec_helper'

feature 'User interacts with queue' do

  given(:the_user) { Fabricate(:user) }

  scenario 'User signs in, adds and reorders videos in the queue' do
    action_movies = Fabricate(:category, name: 'Action')
    the_hunt = Fabricate(:video, title: 'The Hunt', description: 'A description', category: action_movies)
    sign_in(the_user)
    # save_and_open_page
    click_link('TheHunt')
    expect(page).to have_content 'Rate this video'
    click_link('+ My Queue')
    expect(page).to have_content 'List Order'
    click_link('The Hunt')
    expect(page).to have_content 'The Hunt'
    expect(page).to_not have_content '+ My Queue'
  end


end