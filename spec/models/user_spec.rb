require 'spec_helper'

describe User do
  before { @user = User.new(name: "Example User", email: "user@example.com", password: "secret") }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  
  # sanity check, verifying that the @user object is initially valid:
  it { should be_valid }

  describe "when name is not present" do
      before { @user.name = " " }
      it { should_not be_valid }
  end
  
  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end
  describe "when email format is invalid" do
    invalid_addresses =  %w[user@foo,com user_at_foo.org example.user@foo.]
    invalid_addresses.each do |invalid_address|
      before { @user.email = invalid_address }
      it { should_not be_valid }
    end
  end
  describe "when email format is valid" do
     valid_addresses = %w[user@foo.com A_USER@f.b.org frst.lst@foo.jp a+b@baz.cn]
     valid_addresses.each do |valid_address|
       before { @user.email = valid_address }
       it { should be_valid }
     end
   end
   describe "when email address is already taken" do
       before do
         user_with_same_email = User.new(name: "Example User2", email: @user.email, password: "secret2")
         user_with_same_email.save
       end

       it { should_not be_valid }
   end
   describe "when name is already taken" do
       before do
         user_with_same_name = User.new(name: @user.name, email: "user2@example.com", password: "secret2")
         user_with_same_name.save
       end

       it { should_not be_valid }
   end  
   describe "when password is not present" do
     before { @user.password = @user.password_confirmation = " " }
     it { should_not be_valid }
   end
   describe "when password doesn't match confirmation" do
     before { @user.password_confirmation = "mismatch" }
     it { should_not be_valid }
   end
   

end