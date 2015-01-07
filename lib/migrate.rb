# Since we've designed metrics/docs tables to revolve around
# the pods table, but be independent of each other, we can
# run all trunk migrations first, then all others.
#

# NOTE Set the versions to the ones you want to migrate to.
#

# Trunk migrations.
#
Sequel::Migrator.run(
  DB,
  File.join(ROOT, 'migrations/trunk'),
  table: 'schema_info',
  version: 12
)

# Metrics migrations.
#
# TODO Figure out a way to merge this with schema_info.
#
Sequel::Migrator.run(
  DB,
  File.join(ROOT, 'migrations/metrics'),
  # This enables us to have separate migrations
  # for each app.
  table: 'schema_info_metrics',
  version: 3
)

Sequel::Migrator.run(
  DB,
  File.join(ROOT, 'migrations/cocoadocs'),
  # This enables us to have separate migrations
  # for each app.
  table: 'schema_info_cocoadocs',
  version: 3
)


File.open('migrations/schema.txt', 'w') { |file| file.write(schema) }