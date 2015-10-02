require File.expand_path('../snapshots', __FILE__)

# Helper module for all projects in Strata that need
# Database access and management.
#
# Load this in Strata via '../Humus/lib/cocoapods-humus'.
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
      access_key_id = ENV['DUMP_ACCESS_KEY_ID']
      secret_access_key = ENV['DUMP_SECRET_ACCESS_KEY']
      unless access_key_id && secret_access_key
        raise 'Set both DUMP_ACCESS_KEY_ID and DUMP_SECRET_ACCESS_KEY in ENV.'
      end
      
      snapshots = Snapshots.new(access_key_id, secret_access_key)
      begin
        # Seed from dump.
        #
        snapshots.seed_from_dump(name)
        
        # All good. Call the code that needs the snapshot.
        #
        block_given? && yield
      rescue RuntimeError => e # TODO Be more specific.
        unless @retried
          p e
          
          # Load snapshot.
          snapshots.dump_prepared(name)
          
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