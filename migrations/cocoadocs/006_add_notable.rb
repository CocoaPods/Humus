Sequel.migration do
  change do
    alter_table(:cocoadocs_pod_metrics) do
      add_column :notable, :boolean, :default => false
      drop_column :not_found
    end
  end
end
