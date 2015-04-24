Sequel.migration do
  change do
    alter_table(:cocoadocs_cloc_metrics) do
      drop_column :metadata_short
      drop_column :metadata_url
    end
    
    alter_table(:cocoadocs_pod_metrics) do
      add_column :license_short_name, String, :null => true
      add_column :license_canonical_url, String, :null => true
    end
  end
end
