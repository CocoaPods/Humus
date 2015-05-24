# Since we've designed metrics/docs tables to revolve around
# the pods table, but be independent of each other, we can
# run all trunk migrations first, then all others.
#

# Helper method
#
def foreign_key_delete_cascade source_table, target_table, foreign_key
  <<-SQL
    ALTER TABLE #{source_table} DROP CONSTRAINT #{source_table}_#{foreign_key}_fkey; 
    ALTER TABLE #{source_table} ADD FOREIGN KEY (#{foreign_key}) 
      REFERENCES #{target_table} (id)  
      ON DELETE CASCADE;
  SQL
end

# NOTE Set the versions to the ones you want to migrate to.
#

# Trunk migrations.
#
Sequel::Migrator.run(
  DB,
  File.join(ROOT, 'migrations/trunk'),
  table: 'schema_info',
  version: 13
)

["metrics", "cocoadocs", "stats"].each do |db|
  
  Sequel::Migrator.run(
    DB,
    File.join(ROOT, "migrations/#{db}"),
    # This enables us to have separate migrations
    # for each app.
    table: "schema_info_#{db}",
    version: Dir.glob("migrations/#{db}/*").count + 1
  )

end

File.open('migrations/schema.txt', 'w') { |file| file.write(schema) }