def set_current_user(new_user=nil)
  new_user ||= Fabricate(:user)
  session[:user_id] = new_user.id
end

def current_user
  User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end

def sign_in(a_user=nil)
  user = a_user || Fabricate(:user)
  visit sign_in_path
  fill_in "email", with: user.email
  fill_in "password", with: user.password
  click_button 'Sign in'
end

def sign_out(user)
  find_link("Welcome, #{user.full_name}").click
  find_link("Sign Out").click
end