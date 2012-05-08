# == Schema Information
#
# Table name: interested_users
#
#  id         :integer         not null, primary key
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe InterestedUser do
 context "attributes" do
   
 #  before(:each) { @iu = InterstedUser.new}
 #
 #  it "is valid when email format is valid" do
 #    valid_addresses = %w[user@foo.com A_USER@f.b.org frst.lst@foo.jp a+b@baz.cn]
 #    valid_addresses.each do |valid_address|
 #      @iu.email = valid_address
 #      @iu.should be_valid
 #    end
 #  end
 #  
 #  it "is not valid without an email address" do
 #   @iu.should_not be_valid
 #  end
 #  
 #  it "is not valid when email format is not valid" do
 #    invalid_addresses =  %w[user@foo,com user_at_foo.org example.user@foo.]
 #    invalid_addresses.each do |invalid_address|
 #      @iu.email = invalid_address
 #      @iu.should_not be_valid
 #    end
 #  end
 #  
 #
 #  
 end
end
