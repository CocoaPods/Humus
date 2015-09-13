Sequel.migration do
  change do
    create_table(:total_stats) do
      primary_key :id

      Integer :projects_total, :default => 0
      Integer :download_total, :default => 0

      Integer :app_total, :default => 0
      Integer :tests_total, :default => 0
      Integer :extensions_total, :default => 0

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
