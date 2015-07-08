Sequel.migration do
  change do
    alter_table(:cocoadocs_pod_metrics) do
      rename_column :carthage_support, :builds_independently
    end
  end
end
