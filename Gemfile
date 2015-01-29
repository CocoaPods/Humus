source 'https://rubygems.org'
ruby '2.1.3'

gem 'pg'

group :migrations do
  gem 'sequel'
end

group :web do
  gem 'sinatra'
  gem 'thin'
  
  # Database.
  #
  gem 'dm-core', require: true
  gem 'dm-do-adapter', require: true
  gem 'dm-postgres-adapter', require: true
  gem 'flounder'
end

group :development do
  gem 'foreman'
  gem 'heroku'
end

group :rake do
  gem 'rake'
  gem 'terminal-table'
end