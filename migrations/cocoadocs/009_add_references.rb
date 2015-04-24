Sequel.migration do
  up do
    DB.run foreign_key_delete_cascade(:cocoadocs_cloc_metrics, :pods, :pod_id) +
           foreign_key_delete_cascade(:cocoadocs_pod_metrics, :pods, :pod_id)
  end
end
