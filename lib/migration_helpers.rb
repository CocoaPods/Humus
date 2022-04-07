# Since we've designed metrics/docs tables to revolve around
# the pods table, but be independent of each other, we can
# run all trunk migrations first, then all others.
#

# Helper method for cascading deletes.
#
def foreign_key_delete_cascade source_table, target_table, foreign_key
  <<-SQL
    ALTER TABLE #{source_table} DROP CONSTRAINT #{source_table}_#{foreign_key}_fkey;
    ALTER TABLE #{source_table} ADD FOREIGN KEY (#{foreign_key})
      REFERENCES #{target_table} (id)
      ON DELETE CASCADE;
  SQL
end

# Helper method for migrations.
#
def migrate_to(project, version:)
  schema_info_table_name = if project.to_s == 'trunk'
    "schema_info"
  else
    "schema_info_#{project}"
  end

  Sequel::Migrator.run(
    DB,
    File.join(ROOT, "migrations/#{project}"),
    table: schema_info_table_name,
    version: version
  )
end
