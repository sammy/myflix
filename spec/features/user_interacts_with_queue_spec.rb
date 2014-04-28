require 'spec_helper'

feature 'User interacts with queue' do

  given(:the_user) { Fabricate(:user) }

  scenario 'User signs in, adds and reorders videos in the queue' do
    action_movies = Fabricate(:category, name: 'Action')
    the_hunt = Fabricate(:video, title: 'The Hunt', description: 'A description', category: action_movies)
    the_dark_knight = Fabricate(:video, title: 'The Dark Knight', description: 'A description', category: action_movies)
    the_avengers = Fabricate(:video, title: 'The Avengers', description: 'A description', category: action_movies)
    
    sign_in(the_user)
    
    click_link('TheHunt')
    expect(page).to have_content 'Rate this video'
    
    click_link('+ My Queue')
    expect(page).to have_content 'List Order'
    
    click_link('The Hunt')
    expect(page).to have_content 'The Hunt'
    expect(page).to_not have_content '+ My Queue'
    
    visit home_path
    click_link 'TheDarkKnight'
    click_link('+ My Queue')
    
    visit home_path
    click_link 'TheAvengers'
    click_link('+ My Queue')

    fill_in "video_#{the_hunt.id}", with: 3
    fill_in "video_#{the_dark_knight.id}", with: 1
    fill_in "video_#{the_avengers.id}", with: 2
    click_button "Update Instant Queue"

    find_field("video_#{the_hunt.id}").value.should == '3'
    find_field("video_#{the_dark_knight.id}").value.should == '1'
    find_field("video_#{the_avengers.id}").value.should == '2'
  end
end