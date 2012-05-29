# == Schema Information
#
# Table name: user_copies
#
#  id                     :integer         not null, primary key
#  id_orig                :integer
#  email                  :string(255)
#  encrypted_password     :string(255)
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  referer                :string(255)
#  first_name             :string(255)
#  last_name              :string(255)
#  fb_ui                  :string(255)
#

require 'spec_helper'

describe UserCopy do
  pending "add some examples to (or delete) #{__FILE__}"
end
