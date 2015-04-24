Sequel.migration do
  change do
    alter_table(:cocoadocs_pod_metrics) do
      add_column :quality_estimate, Integer, :default => 0
    end
  end
end
