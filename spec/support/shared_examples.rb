shared_examples "require log-in" do
  it "redirects to sign_in_path" do
    clear_current_user
    action
    response.should redirect_to sign_in_path
  end
end