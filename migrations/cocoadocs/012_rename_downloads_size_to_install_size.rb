Sequel.migration do
  change do
    alter_table(:cocoadocs_pod_metrics) do
      rename_column :download_size, :install_size
    end
  end
end
