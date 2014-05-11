shared_examples "require log-in" do
  
  it "redirects to sign_in_path" do
    clear_current_user
    action
    response.should redirect_to sign_in_path
  end
end

shared_examples "require admin log-in" do

  it "redirects to home path when user is not an admin" do
    set_current_user
    action
    response.should redirect_to root_path
  end

  it "displays an error message" do
    set_current_user
    action
    expect(flash[:error]).to eq("Not authorized!")
  end
end

