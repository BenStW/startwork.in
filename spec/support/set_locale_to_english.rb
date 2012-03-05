=begin
class ApplicationController
  before_filter :set_locale_to_english

  def set_locale_to_english
    I18n.locale = :en
  end
end
=end
=begin
class ActionController::TestCase
  module Behavior
    def process_with_default_locale(action, parameters = nil, session = nil, flash = nil, http_method = 'GET')
      parameters = { :locale => :en }.merge( parameters || {} )
      process_without_default_locale(action, parameters, session, flash,http_method)
    end
    alias_method_chain :process, :default_locale
  end
end


module ActionDispatch::Assertions::RoutingAssertions
  def assert_recognizes_with_default_locale(expected_options, path,extras={}, message=nil)
    expected_options = { :locale => :en}.merge(expected_options || {} )
    assert_recognizes_without_default_locale(expected_options, path,extras, message)
  end
  alias_method_chain :assert_recognizes, :default_locale
end
=end