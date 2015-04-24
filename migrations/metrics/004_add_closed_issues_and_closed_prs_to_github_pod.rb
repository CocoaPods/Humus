Sequel.migration do
  change do
    alter_table(:github_pod_metrics) do
      add_column :closed_issues, Integer, :null => true
      add_column :closed_pull_requests, Integer, :null => true
    end
  end
end
