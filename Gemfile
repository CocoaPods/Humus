source 'https://rubygems.org'

ruby '3.1.1' if ENV['RACK_ENV'] == 'production' || ENV['CI'] == 'true'

gem 'pg'

group :migrations do
  gem 'sequel'
end

group :web do
  gem 'sinatra'
  gem 'thin'
end

group :database do
  gem 'flounder'
end

group :development do
  gem 'foreman'
  # gem 'heroku' # Install https://toolbelt.heroku.com.
end

group :rake do
  gem 'rake'
  gem 'terminal-table'
end

group :dumping do
  gem 's3'
  # The S3 gem will fail to download DB dumps at runtime without this
  gem 'rexml'
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
