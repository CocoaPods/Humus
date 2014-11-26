desc 'Bootstrap the project'
task :bootstrap do
  sh 'bundle install'
end

begin
  require 'rubygems'
  require 'bundler/setup'

  task :env do
    $LOAD_PATH.unshift(File.expand_path('../', __FILE__))
    require 'config/init'
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
      DB.tables.each do |table|
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
      sh "dropdb trunk_cocoapods_org_#{ENV['RACK_ENV']}"
    end

    desc 'Create DB for RACK_ENV'
    task :create => :rack_env do
      sh "createdb -h localhost trunk_cocoapods_org_#{ENV['RACK_ENV']} -E UTF8"
    end

    desc 'Seed DB to the given version at a certain date'
    task :seed, [:date] => :rack_env do
      raise "Not yet implemented error"
    end

    desc 'Create and migrate the DB for RACK_ENV'
    task :bootstrap => [:create, :migrate]

    desc 'Drop and then bootstrap the DB for RACK_ENV'
    task :reset => [:drop, :bootstrap]
  end
  
rescue SystemExit, LoadError => e
  puts "[!] The normal tasks have been disabled: #{e.message}"
end