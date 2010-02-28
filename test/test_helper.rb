ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  class << self
    # Class method for test helpers
    def self.test_helper(*names)
      names.each do |name|
        name = name.to_s
        name = $1 if name =~ /^(.*?)_test_helper$/i
        name = name.singularize
        first_time = true
        begin
          constant = (name.camelize + 'TestHelper').constantize
          self.class_eval { include constant }
        rescue NameError
          filename = File.expand_path(TEST_ROOT + '/helpers/' + name + '_test_helper.rb')
          require filename if first_time
          first_time = false
          retry
        end
      end
    end
    alias :test_helpers :test_helper
  end
end
