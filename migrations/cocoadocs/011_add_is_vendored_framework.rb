Sequel.migration do
  change do
    alter_table(:cocoadocs_pod_metrics) do
      add_column :is_vendored_framework, :boolean, :default => false
    end
  end
end
