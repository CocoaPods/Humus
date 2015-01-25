Sequel.migration do
  change do
    alter_table(:cocoadocs_pod_metrics) do
      add_column :queued_at, DateTime, :null => true
    end
  end
end
