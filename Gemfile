source 'https://rubygems.org'
ruby '2.1.3'

gem 'pg'

group :migrations do
  gem 'sequel'
end

group :web do
  gem 'sinatra'
  gem 'thin'
end

group :database do
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

# Pure test gems.
#
group :test do
  # gem 'rack-test'
  gem 'kicker'
  # gem 'mocha', '~> 0.11.4'
  gem 'bacon'
  # gem 'mocha-on-bacon'
  gem 'prettybacon', :git => 'https://github.com/irrationalfab/PrettyBacon.git', :branch => 'master', :require => 'pretty_bacon'
end