# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  name                   :string(255)
#

require 'spec_helper'

describe User do
  fixtures :users   
  before { @user = users(:ben) }
    #User.new(name: "Example User", email: "user@example.com", password: "secret") 

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
   it "creates a new user with an existing email" do
     user_with_same_email = User.new(name: "Example User2", email: @user.email, password: "secret2")
     user_with_same_email.save
     user_with_same_email.should_not be_valid
   end
   it "creates a new user with an existing name" do
     user_with_same_name = User.new(name: @user.name, email: "user2@example.com", password: "secret2")
     user_with_same_name.should_not be_valid     
   end  
   
   describe "when password is not present" do
     before { @user.password = @user.password_confirmation = " " }
     it { should_not be_valid }
   end
   describe "when password doesn't match confirmation" do
     before { @user.password_confirmation = "mismatch" }
     it { should_not be_valid }
   end
   
  it "creates and closes a connection" do
       should_not be_open_connections
       @user.start_connection
       should be_open_connections
       @user.end_connection
       should_not be_open_connections        
  end

end
