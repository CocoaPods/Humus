desc 'Bootstrap the project'
task :bootstrap do
  sh 'bundle install'
end

begin
  require 'rubygems'
  require 'bundler/setup'

  task :rack_env do
    ENV['RACK_ENV'] ||= 'development'
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
      # ENV['TRUNK_APP_LOG_TO_STDOUT'] = 'true'
      Rake::Task[:env].invoke
      version = ENV['VERSION'].to_i if ENV['VERSION']
      Sequel::Migrator.run(DB, File.join(ROOT, 'db/migrations'), :target => version)
      File.open('db/schema.txt', 'w') { |file| file.write(schema) }
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