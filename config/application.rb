require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Reflections
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.action_dispatch.use_authenticated_cookie_encryption = false
    config.enable_dependency_loading = true
    Rails.application.config.active_support.use_sha1_digests = true

    # Rails 6
    config.action_dispatch.use_cookies_with_metadata = true
    config.active_record.cache_versioning = true

    Rails::Html::WhiteListSanitizer.allowed_tags << "iframe"

  end
end
