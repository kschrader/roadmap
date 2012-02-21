source 'http://rubygems.org'

gem 'rails', '3.1.3'
gem 'jquery-rails'

gem 'haml', '~> 3.0'
gem 'haml-rails'

gem 'bilge-pump',
  git: 'git://github.com/flipstone/bilge-pump.git', 
  branch: '3390d04'

gem 'mongo', '1.3.1'
gem 'bson', '1.3.1'
gem 'bson_ext', '1.3.1'
gem 'mongo_mapper', '0.9.2'
gem 'mongo_session_store', require: 'mongo_session_store/mongo_mapper'

gem 'unicorn'
gem 'capistrano', '~> 2.5'
gem 'flipstone-deployment', git: 'git://github.com/flipstone/flipstone-deployment.git', branch: 'fc71e69'

gem "pivotal-tracker", "~> 0.5.1"

group :test, :development, :cruise do
  # Pretty printed test output
  gem 'turn', '0.8.2', :require => false
  gem 'rspec'
  gem 'rspec-rails'
  gem 'factory_girl'
  gem 'factory_girl_rails'
end
