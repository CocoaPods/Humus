Sequel.migration do
  change do
    alter_table(:cocoadocs_pod_metrics) do
      drop_column :notability
      add_column :changelog_url, String, :null => true
      add_column :rendered_summary, String, :null => true
    end
  end
end
