require 'spec_helper'

feature 'Video upload' do 

  scenario 'Admin logs in and uploads video' do
    
    the_admin = Fabricate(:user, is_admin: true)
    Fabricate(:category, name: 'Comedies')
    large_cover = File.join(Rails.root, "app/assets/images/monk_large.jpg")
    small_cover = File.join(Rails.root, "app/assets/images/monk.jpg")

    visit sign_in_path
    sign_in(the_admin)
    visit new_admin_video_path
    expect(page).to have_content 'Add a New Video'

    fill_in "Title", with: 'A Test Video'
    find("option[value='1']").click
    fill_in "Description", :with => 'A short description'
    attach_file('video_large_cover', large_cover)
    attach_file('video_small_cover', small_cover)
    fill_in "Video url", :with => 'https://s3-eu-west-1.amazonaws.com/bckt.full.of.sand/videos/The-Big-White---Sample.mp4'
    click_button "Add Video"
    expect(page).to have_content "Succesfully saved video 'A Test Video'"

    click_link 'Sign Out'

    the_user = Fabricate(:user)

    visit sign_in_path
    sign_in(the_user)
    expect(page).to have_content('Comedies')
    page.has_css?('a#ATestVideo') 
    page.should have_xpath("//img[contains(@src,\"https://s3-eu-west-1.amazonaws.com/dev-bckt.full.of.crap/images/video/1_ATestVideo_small_cover\")]")
    
    click_link 'ATestVideo'

    expect(page).to have_content('Watch Now')

    page.should have_xpath("/html/body/section/article/div/div/div[2]/div/a[1][contains(@href, \"https://s3-eu-west-1.amazonaws.com/bckt.full.of.sand/videos/The-Big-White---Sample.mp4\")]")
  end
end