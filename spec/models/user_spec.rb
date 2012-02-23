require 'spec_helper'

describe User do
  before { @user = User.new(name: "Example User", email: "user@example.com", password: "secret") }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  
  # sanity check, verifying that the @user object is initially valid:
  it { 
    should be_valid
    puts @user.to_yaml
    puts @user.valid?
    puts @user.errors.to_yaml

#    puts errors.to_yaml
     }

    describe "when name is not present" do
      before { @user.name = " " }
      it { should_not be_valid }
    end
end