Sequel.migration do
  change do
    alter_table(:cocoadocs_cloc_metrics) do
      add_column :metadata_short, String, :null => true
      add_column :metadata_url, String, :null => true
    end
  end
end
