Rails.autoloaders.each do |autoloader|
  autoloader.inflector.inflect(
    'csv' => 'CSV'
  )
end

# Rails.autoloaders.main.ignore(Rails.root.join('config/initializers/rails_admin.rb'))
autoloader = Rails.autoloaders.main
# autoloader.collapse("app/concepts/**/operation")
# For now the following lines are hard coded but should be replaced by the one above when all ops are fixed.

