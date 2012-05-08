# == Schema Information
#
# Table name: invitations
#
#  id             :integer         not null, primary key
#  sender_id      :integer
#  recipient_mail :string(255)
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

require 'spec_helper'

describe Invitation do
  context "attributes" do

     before(:each) do 
       @invitation = FactoryGirl.build(:invitation)
     end
     
     it "is valid with factory attributes" do
       @invitation.should be_valid
     end

     it "is valid when email format of recipient is valid" do
       valid_addresses = %w[user@foo.com A_USER@f.b.org frst.lst@foo.jp a+b@baz.cn]
       valid_addresses.each do |valid_address|
         @invitation.recipient_mail = valid_address
         @invitation.should be_valid
       end
     end

     it "is not valid without an email address of recipient" do
       @invitation.recipient_mail = nil
       @invitation.should_not be_valid
     end
     
     it "is not valid without a sender" do
       @invitation.sender = nil
       @invitation.should_not be_valid
     end     

     it "is not valid when email format of recipient is not valid" do
       invalid_addresses =  %w[user@foo,com user_at_foo.org example.user@foo.]
       invalid_addresses.each do |invalid_address|
         @invitation.recipient_mail = invalid_address
         @invitation.should_not be_valid
       end
     end

   end
end
