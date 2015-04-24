Sequel.migration do
  up do
    DB.run foreign_key_delete_cascade(:github_pod_metrics, :pods, :pod_id)
  end
end
