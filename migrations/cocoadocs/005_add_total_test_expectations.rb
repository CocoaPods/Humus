Sequel.migration do
  change do
    alter_table(:cocoadocs_pod_metrics) do
      add_column :total_test_expectations, Integer, :null => true
    end
  end
end
