Sequel.migration do
  change do
    alter_table(:stats_metrics) do

      add_column :extension_week, Integer, :default => 0
      add_column :extension_total, Integer, :default => 0

      drop_column :extension_keyboard_total
      drop_column :extension_keyboard_week
      drop_column :extension_action_total
      drop_column :extension_action_week
      drop_column :extension_share_total
      drop_column :extension_share_week
      drop_column :extension_watch_total
      drop_column :extension_watch_week
      drop_column :extension_today_total
      drop_column :extension_today_week

    end
  end
end
