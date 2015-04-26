Sequel.migration do
  up do
    DB.run foreign_key_delete_cascade(:pod_versions, :pods,         :pod_id) +
           foreign_key_delete_cascade(:commits,      :pod_versions, :pod_version_id) +
           foreign_key_delete_cascade(:commits,      :owners,       :committer_id) +
           foreign_key_delete_cascade(:owners_pods,  :owners,       :owner_id) +
           foreign_key_delete_cascade(:owners_pods,  :pods,         :pod_id) +
           foreign_key_delete_cascade(:disputes,     :owners,       :claimer_id) +
           foreign_key_delete_cascade(:log_messages, :owners,       :owner_id) +
           foreign_key_delete_cascade(:log_messages, :pod_versions, :pod_version_id) +
           foreign_key_delete_cascade(:sessions,     :owners,       :owner_id)
  end
end
