source 'https://rubygems.org'
ruby "2.2.2"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'

#mongo
gem 'mongoid-tree'
gem 'mongoid'
gem 'bson_ext'

#front-end
gem 'haml-rails'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'bootstrap-sass', '~> 3.3.1'
gem 'autoprefixer-rails'
gem 'jbuilder', '~> 2.0'
gem 'turbolinks'

#background job
gem 'sidekiq'

#core
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'unicorn'
gem 'rack-timeout'

#social
gem 'devise'
gem 'fb_graph'
gem 'omniauth'
gem 'omniauth-facebook'

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

#real estate
gem 'street_easy', path: '../street_easy'
gem 'rubillow'

group :production do
  gem 'rails_12factor'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'mongoid-rspec', '~> 2.0.0.rc1'
  gem 'factory_girl_rails'
  gem 'fuubar'
  gem 'faker'
  gem 'pry'
  gem 'pry-remote'
  gem 'capybara'
  gem 'shoulda-matchers'
  gem 'database_cleaner'
  gem 'dotenv-rails'
end
