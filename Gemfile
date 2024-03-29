source 'https://rubygems.org'
ruby '2.4.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.8.rc1'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'nested_form'

gem 'rollbar'
gem 'spree_sitemap', github: 'spree-contrib/spree_sitemap', branch: '3-1-stable'

gem 'annotate'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'pry-rails'
  gem 'faker'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
end

group :test do
  gem 'rspec-rails'

  gem 'timecop'
  gem 'webmock'

  gem 'shoulda-matchers', '~> 3.1'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'letter_opener'
end

group :development do
  gem 'capistrano', '~> 3.6'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-rbenv', '~> 2.0'
  gem 'capistrano-rbenv-vars'
  gem 'capistrano-bundler'
  gem 'capistrano3-puma'
  gem 'capistrano-rails-db'
  gem 'capistrano-postgresql', '~> 4.2.0'
  gem 'capistrano-sidekiq'
end

gem 'fog',                     '1.38.0'

gem 'rails_db'

gem 'spree', '~> 3.1.0'
gem 'spree_auth_devise', '~> 3.1.0'
gem 'spree_gateway', '~> 3.1.0'
gem "font-awesome-rails"

gem 'spree_i18n', github: 'spree-contrib/spree_i18n', branch: '3-1-stable'

gem 'spree_volume_pricing', :git => 'https://github.com/lsantobuono/spree_volume_pricing.git', branch: 'master'

gem 'puma', '~> 4.3.5'

gem 'carrierwave', '>= 1.0.0.rc', '< 2.0'

gem "spreadsheet"

gem 'aws-sdk', '< 2.0'
gem 'whenever', :require => false

gem 'spree_print_invoice', github: 'spree-contrib/spree_print_invoice', branch: 'master'

group :development do
  gem 'meta_request'
end

gem 'summernote-rails', '0.8.1'
gem 'bootstrap-sass'     # required

gem 'haml-rails', '~> 0.9'

gem 'ancestry'
gem 'sortable_tree_rails'

gem 'jquery-ui-rails'

gem 'mercadopago-sdk'


gem "recaptcha"
