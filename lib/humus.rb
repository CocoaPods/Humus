require 'rake'

# Helper module for all projects in Strata that need
# Database access and management.
#
# Load this in Strata via '../Humus/lib/humus'.
# Then use the Humus helper methods:
#  * Humus.with_snapshot(name, options = {})
#
module Humus
  
  # Load a specific snapshot into the database.
  #
  # Use this in integration tests in a CP project.
  #
  # Note: Does not ROLLBACK yet!
  #
  # @param [String] name The name of the snapshot.
  # @param [Hash]   options Options: env, seed, rollback (not implemented yet).
  #
  # @example 
  #   Humus.with_snapshot('b008') do
  #     # Do something for which you need snapshot b008.
  #   end
  #
  def self.with_snapshot name, options = {}
    environment = options[:env]      || ENV['RACK_ENV'] || 'test'
    seed        = options[:seed]     || true
    rollback    = options[:rollback] && raise("Option :rollback not implemented yet.")
    
    # Currently, we only want this for tests.
    #
    return unless environment == 'test' 
    
    # If seed is falsy, just yield.
    #
    if seed
      # Load Humus Rakefile tasks.
      #
      # FIXME This is very optimistic and assumes
      # there's no collision between project tasks
      # and Humus tasks.
      #
      load File.expand_path('../../Rakefile', __FILE__)
      
      begin
        # Seed from dump.
        #
        Rake::Task['db:test:seed_from_dump'].invoke(name)
        
        # All good. Call the code that needs the snapshot.
        #
        block_given? && yield
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
      block_given? && yield
    end
  end
  
end