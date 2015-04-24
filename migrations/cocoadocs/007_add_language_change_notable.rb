Sequel.migration do
  change do
    alter_table(:cocoadocs_pod_metrics) do
      drop_column :notable
      add_column :notability, Integer, :default => 0
      
      add_column :dominant_language, String, :null => true
    end
  end
end
