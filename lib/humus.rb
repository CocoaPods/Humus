require 'rake'

# Helper module for all projects in Strata that need
# Database access and management.
#
module Humus
  
  # Load a specific snapshot into the database.
  #
  # @example 
  #   Humus.with_snapshot('b008') do
  #     # Do something for which you needs snapshot b008.
  #   end
  #
  def self.with_snapshot name, options = {}
    environment = options[:env] || ENV['RACK_ENV'] || 'test'
    load_dump = options[:load_dump] || true
    
    # Currently, we only want this for tests.
    #
    return unless environment == 'test' 
    
    # If load_dump is falsy, just yield.
    #
    if load_dump
      # Load Rakefile tasks.
      #
      load 'Rakefile'
      
      begin
        # Seed from dump.
        #
        Rake::Task['db:test:seed_from_dump'].invoke(name)
        
        # All good. Call the code that needs the snapshot.
        #
        yield
      rescue RuntimeError => e # TODO Be more specific.
        unless @retried
          p e
          
          # Load snapshot.
          #
          Rake::Task['db:test:dump'].invoke(name)
          
          # And retry to seed.
          #
          retry
        end
        @retried = true
      end
    else
      yield
    end
  end
  
end