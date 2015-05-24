Sequel.migration do
  change do
    create_table(:stats_metrics) do
      primary_key :id
      foreign_key :pod_id, :pods, :null => false, :key => [:id]

      Integer :download_total, :default => 0
      Integer :download_week, :default => 0
      Integer :download_month, :default => 0

      Integer :app_total, :default => 0
      Integer :app_week, :default => 0

      Integer :tests_total, :default => 0
      Integer :tests_week, :default => 0

      Integer :extension_keyboard_total, :default => 0
      Integer :extension_keyboard_week, :default => 0

      Integer :extension_action_total, :default => 0
      Integer :extension_action_week, :default => 0
      
      Integer :extension_share_total, :default => 0
      Integer :extension_share_week, :default => 0

      Integer :extension_watch_total, :default => 0
      Integer :extension_watch_week, :default => 0

      Integer :extension_today_total, :default => 0
      Integer :extension_today_week, :default => 0

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
