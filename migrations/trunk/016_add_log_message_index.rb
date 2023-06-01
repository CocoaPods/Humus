Sequel.migration do
  change do
    alter_table :log_messages do
      add_index [:pod_version_id], :unique => false
    end
  end
end
