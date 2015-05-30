Sequel.migration do
  change do
    alter_table :owners do
      add_column :is_verified, :boolean, :default => false
    end
  end
end
