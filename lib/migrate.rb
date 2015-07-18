require_relative 'migration_helpers'

# Since we've designed metrics/docs tables to revolve around
# the pods table, but be independent of each other, we can
# run all trunk migrations first, then all others.
#
migrate_to :trunk, version: 14

# These next few lines mark the current production migration versions.
#
# Important:
# Update and push only just before you are going to migrate in production.
#
migrate_to :metrics,   version:  5
migrate_to :cocoadocs, version: 16
migrate_to :stats,     version:  4

# Write the resulting schema into a file.
#
File.open('migrations/schema.txt', 'w') { |file| file.write(schema) }
