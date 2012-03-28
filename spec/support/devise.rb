RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
#  config.stretches = Rails.env.test? ? 1 : 10
end

