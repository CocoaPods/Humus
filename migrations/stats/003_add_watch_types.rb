Sequel.migration do
  change do
    alter_table(:stats_metrics) do

      add_column :watch_week, Integer, :default => 0
      add_column :watch_total, Integer, :default => 0

    end
  end
end
