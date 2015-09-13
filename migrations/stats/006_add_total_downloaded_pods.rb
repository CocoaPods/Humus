Sequel.migration do
  change do
    alter_table(:total_stats) do
      add_column :total_downloaded_pods, Integer, :default => 0
    end
  end
end
