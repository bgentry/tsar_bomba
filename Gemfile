source 'https://rubygems.org'

ruby '2.1.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.0.beta4'
# Use postgresql as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets with Bootstrap
gem 'sass-rails', '~> 5.0.0.beta1'
gem 'bootstrap-sass', '~> 3.2.0'
gem 'bootstrap-generators', '~> 3.1.1'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'haml-rails'

# Use jQuery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Puma as the app server
gem 'puma'

gem 'flipper'
gem 'flipper-activerecord'
gem 'fog'
gem 'net-ssh'
gem 'quantile'
gem 'que'
gem 'workflow'

group :development, :test do
  gem 'awesome_print'
  gem "factory_girl_rails"
  gem 'guard-bundler', require: false
  gem 'guard-rspec'
  if RUBY_PLATFORM.downcase.include?("darwin")
    gem 'rb-fsevent'
    gem 'rspec-nc'
  end

  # Call 'debugger' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'rspec-rails'
  gem "shoulda-matchers", require: false
end

group :test do
  gem 'database_cleaner'
end

group :development, :production do
  gem 'rails_12factor'
end
