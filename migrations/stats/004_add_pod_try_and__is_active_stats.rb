Sequel.migration do
  change do
    alter_table(:stats_metrics) do

      add_column :pod_try_week, Integer, :default => 0
      add_column :pod_try_total, Integer, :default => 0

      add_column :is_active, :boolean, :default => false
    end
  end
end
