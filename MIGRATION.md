# Migration from Webpacker to esbuild

This document describes the migration from Webpacker to esbuild for JavaScript bundling in this project.

## Changes Made

1. Added the jsbundling-rails gem to the Gemfile:
   ```ruby
   # Use jsbundling-rails for JavaScript bundling with esbuild
   gem "jsbundling-rails"
   ```

2. Removed the webpack configuration files:
   - config/webpack/development.js
   - config/webpack/environment.js
   - config/webpack/production.js
   - config/webpack/test.js

3. Removed the jquery dependency from package.json, as it was already marked for removal in favor of vanilla JavaScript.

4. Created a Procfile.dev file for development:
   ```
   web: bin/rails server -p 3000
   js: yarn build --watch
   ```

5. Created a bin/dev script for development:
   ```bash
   #!/usr/bin/env bash

   if ! command -v foreman &> /dev/null
   then
     echo "Installing foreman..."
     gem install foreman
   fi

   foreman start -f Procfile.dev
   ```

6. Made the bin/dev script executable:
   ```bash
   chmod +x bin/dev
   ```

7. Updated the README.md file with development setup instructions and information about the new JavaScript bundling setup.

## Testing the Migration

To test the migration:

1. Run `bundle install` to install the jsbundling-rails gem
2. Run `yarn install` to update dependencies
3. Run `yarn build` to build the JavaScript files
4. Run `bin/dev` to start the development server
5. Verify that the application works as expected

## Troubleshooting

If you encounter any issues, please check the following:

- Make sure the app/assets/builds directory exists and is writable
- Make sure the esbuild.config.js file is correctly configured
- Check the browser console for any JavaScript errors

## Why esbuild?

esbuild is a modern JavaScript bundler that is much faster than webpack. It's also simpler to configure and use. The Rails team recommends using esbuild for new Rails 7+ applications.

## References

- [jsbundling-rails gem](https://github.com/rails/jsbundling-rails)
- [esbuild](https://esbuild.github.io/)
- [Rails 7 JavaScript Bundling](https://guides.rubyonrails.org/working_with_javascript_in_rails.html#bundling-javascript-in-rails)