Sequel.migration do
  change do
    alter_table :pod_versions do
      add_column :deleted, :boolean, :null => false, :default => false
    end
  end
end
