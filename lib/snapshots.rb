module Humus
  
  class Snapshots
    
    attr_reader :access_key_id
    attr_reader :secret_access_key
    
    def initialize access_key_id = nil, secret_access_key = nil
      @access_key_id = access_key_id
      @secret_access_key = secret_access_key
    end
    
    def dump_prepared id
      name = "trunk-#{id}.dump"
      target_path = File.expand_path("../../fixtures/#{name}", __FILE__)
      
      puts "Accessing prepared DB test snapshot #{id} from S3."
      
      require 's3'
      service = S3::Service.new(:access_key_id => access_key_id, :secret_access_key => secret_access_key)
      bucket = service.buckets.find("cocoapods-org-testing-dumps")
      
      # Due to a bug in the s3 gem we are searching for the object via iterating.
      bucket.objects.each do |obj|
        if obj.key == name
          puts "Downloading prepared DB test snapshot #{id} from S3."
          File.open(target_path, 'w') do |file|
            file.write(obj.content)
          end
          break
        end
      end
      
      puts "Prepared DB test snapshot #{id} downloaded to #{target_path}"
    end
    
    def seed_from_dump id
      target_path = File.expand_path("../../fixtures/trunk-#{id}.dump", __FILE__)
      raise "Dump #{id} could not be found." unless File.exists? target_path
      
      puts "Restoring #{ENV['RACK_ENV']} database from #{target_path}"
      
      # Ensure we're starting from a clean DB.
      system "dropdb trunk_cocoapods_org_test"
      system "createdb trunk_cocoapods_org_test"
      
      # Restore the DB.
      command = "pg_restore --no-privileges --clean --no-acl --no-owner -h localhost -d trunk_cocoapods_org_test #{target_path}"
      puts "Executing:"
      puts command
      puts
      result = system command
      if result
        puts "Database #{ENV['RACK_ENV']} restored from #{target_path}"
      else
        warn "Database #{ENV['RACK_ENV']} restored from #{target_path} with some errors."
        # exit 1
      end
    end
    
    def dump_prod id
      target_path = File.expand_path("../../fixtures/trunk-#{id}.dump", __FILE__)
      puts "Dumping production database from Heroku (works only if you have access to the database)"
      command = "curl -o #{target_path} \`heroku pg:backups public-url #{id} -a cocoapods-trunk-service\`"
      puts "Executing command:"
      puts command
      result = system command
      if result
        puts "Production database snapshot #{id} dumped into #{target_path}"
      else
        raise "Could not dump #{id} from production database."
      end
    end
    
  end
  
end