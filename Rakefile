desc 'Bootstrap the project'
task :bootstrap do
  sh 'bundle install'
end

begin
  require 'rubygems'
  require 'bundler/setup'
  require 'bundler/gem_tasks'

  task :env do
    $LOAD_PATH.unshift(File.expand_path('../', __FILE__))
    require 'config/init'
  end

  task :test_env do
    ENV['RACK_ENV'] = 'test'
  end

  task :rack_env do
    ENV['RACK_ENV'] ||= 'development'

    if ENV['RACK_ENV'] == 'production'
      puts "Are you very very sure what you are doing? very/no/maybe"
      exit unless STDIN.gets.strip == 'very'

      puts "Are you really really sure? really/naah"
      exit unless STDIN.gets.strip == 'really'

      puts "Last chance: Absolutely sure? absolutely/nope"
      exit unless STDIN.gets.strip == 'absolutely'
    end
  end

  namespace :db do
    def schema
      require 'terminal-table'
      result = ''
      # Tables are printed in alphabetical order.
      DB.tables.sort.each do |table|
        result << "#{table}\n"
        schema = DB.schema(table)
        terminal_table = Terminal::Table.new(
          headings: [:name, *schema[0][1].keys],
          rows: schema.map { |c| [c[0], *c[1].values.map(&:inspect)] }
        )
        result << "#{terminal_table}\n\n"
      end
      result
    end

    desc 'Show schema'
    task schema: :env do
      puts schema
    end

    desc 'Run migrations'
    task :migrate => :rack_env do
      Rake::Task[:env].invoke

      # Run migrations.
      #
      require 'lib/migrate'
    end

    desc 'Drop DB for RACK_ENV'
    task :drop => :rack_env do
      exists = `psql -l | grep trunk_cocoapods_org_test`
      unless exists.empty?
        sh "dropdb trunk_cocoapods_org_#{ENV['RACK_ENV']}"
      end
    end

    desc 'Create DB for RACK_ENV'
    task :create => :rack_env do
      sh "createdb -h localhost trunk_cocoapods_org_#{ENV['RACK_ENV']} -E UTF8"
    end

    desc 'Drop, create and migrate the DB for RACK_ENV'
    task :bootstrap => [:drop, :create, :migrate]

    desc 'Drop and then bootstrap the DB for RACK_ENV'
    task :reset => [:drop, :bootstrap]

    namespace :test do
      desc "Get prepared dump from S3."
      task :dump, :id do |_, args|
        access_key_id = ENV['DUMP_ACCESS_KEY_ID']
        secret_access_key = ENV['DUMP_SECRET_ACCESS_KEY']
        unless access_key_id && secret_access_key
          raise 'Set both DUMP_ACCESS_KEY_ID and DUMP_SECRET_ACCESS_KEY in ENV.'
        end

        require File.expand_path '../lib/snapshots', __FILE__
        snaps = Humus::Snapshots.new(access_key_id, secret_access_key)
        snaps.download_prepared_dump(args.id)
      end

      desc 'Seed test DB from a named production dump'
      task :seed_from_dump, [:id] => :test_env do |_, args|
        require File.expand_path '../lib/snapshots', __FILE__
        snaps = Humus::Snapshots.new
        snaps.seed_from_dump(args.id)
      end

      # The dump ID comes from: https://data.heroku.com/datastores/a22141e3-f63e-4ccc-be03-7e09a742f687#durability
      desc "Get prod dump."
      task :prod_dump, :id do |_, args|
        require File.expand_path '../lib/snapshots', __FILE__
        snaps = Humus::Snapshots.new
        snaps.dump_prod(args.id)
      end
    end
  end

  desc 'Install tools for running the site'
  task :install_tools do
    if `mdfind kind:application Postgres93.app`.length == 0 && `mdfind kind:application Postgres.app`.length == 0
      puts "Postgres93.app was not found, would you like us to install it for you? yes/no"
      puts "this will install homebrew, and brew cask for you if not installed."

      exit unless STDIN.gets.strip == 'yes'

      if `which brew`.length == 0
        Bundler.with_clean_env do
          `ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
        end
      end

      if Dir.exists?("/usr/local/Library/Taps/caskroom/homebrew-cask") == false
        Bundler.with_clean_env do
          `brew install caskroom/cask/brew-cask`
        end
      end

      Bundler.with_clean_env do
        `brew cask install postgres`
      end

      puts "Installed Postgres app, this app hosts your database while it is being ran."

      puts "You will need to add the following line to your ~/.bash_profile or ~/.bashrc file:"
      puts "\"export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/9.4/bin\""

    end
  end

  desc 'Migrate CocoaPods db into local'
  task :migrate_from_heroku do
    database_url = ""
    Bundler.with_clean_env do
      database_url = `heroku config:get DATABASE_URL --app cocoapods-org`.strip
    end

    tmp_file = "/tmp/cocoapods_trunk.sql"
    puts "Downloading from the server, this will take a while"
    puts "pg_dump #{database_url} -f #{tmp_file}"

    `pg_dump #{database_url} -f #{tmp_file}`

    puts "Downloaded, dropping old trunk_cocoapods_org_development db"
    `echo "DROP DATABASE trunk_cocoapods_org_development" | psql postgres://localhost`
    `echo "CREATE DATABASE trunk_cocoapods_org_development" | psql postgres://localhost`

    `psql postgres://localhost/trunk_cocoapods_org_development -f #{tmp_file}`
  end

  namespace :spec do
    def specs dir = '**'
      FileList["spec/#{dir}/*_spec.rb"].shuffle.join ' '
    end

    desc "Automatically run specs for updated files"
    task :kick do
      exec "bundle exec kicker -c"
    end

    desc "Run all specs"
    task :all do
      sh "bundle exec bacon #{specs}"
    end
  end

  desc "Run all specs"
  task :spec => 'spec:all'

rescue SystemExit, LoadError => e
  puts "[!] The normal tasks have been disabled: #{e.message}"
end

task :default => :spec
