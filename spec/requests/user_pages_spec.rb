require 'spec_helper'

describe "User pages" do
  subject {page}
  
  describe "signup pages" do
    before { visit "/users/sign_up"}
    
    it { should have_selector('h2', text: "Sign up") }
  end
end
