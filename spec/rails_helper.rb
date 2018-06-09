ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production

abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
require 'spec_helper'
require "shoulda/matchers"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include(Shoulda::Matchers::ActiveRecord, type: :model)
  config.include(Shoulda::Matchers::ActiveModel, type: :model)

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.infer_base_class_for_anonymous_controllers = false
end
