source "https://rubygems.org"

ruby "3.2.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails"
gem "rails", '>= 7.0'
gem "pg"
gem "chartkick"

gem "aws-sdk-s3", require: false

gem 'image_processing', '~> 1.2'

# Use Puma as the app server
gem "puma"
# Use SCSS for stylesheets
gem "sass-rails"
# Use jsbundling-rails for JavaScript bundling with esbuild
gem "jsbundling-rails"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem "therubyracer", platforms: :ruby
gem 'jbuilder', '~> 2.7'

gem "rest-client"

# gem "jquery-rails" # Removed in favor of vanilla JavaScript

gem "devise"
gem "slim"
gem "simple_form"

gem "redcarpet"

gem 'pagy'
gem 'turbo-rails'

group :test do
  gem "simplecov", require: false
  gem "database_cleaner"
  gem "shoulda-matchers", require: false
  gem "timecop"
  gem "webmock", require: false
  gem "selenium-webdriver"
  gem 'rails-controller-testing'
end

group :development, :test do
  # Call "byebug" anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]

  gem "awesome_print"
  gem "brakeman", require: false
  gem "bundler-audit"
  gem "byebug"
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "fuubar"
  gem "jasmine"
  # gem "jasmine-jquery-rails" # Removed in favor of vanilla JavaScript
  gem "pry-rails"
  gem "rails_best_practices"
  gem "rspec-rails"
  gem "rubocop"
  gem "scss_lint", require: false
end

group :staging, :production do
  gem "rails_12factor"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem "web-console", ">= 3.3.0"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "letter_opener"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end


# Use Redis for Action Cable
gem "redis", "~> 4.0"
