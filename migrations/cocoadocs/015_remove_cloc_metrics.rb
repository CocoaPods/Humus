Sequel.migration do
  up do
    drop_table(:cocoadocs_cloc_metrics)
  end

  down do
    create_table(:cocoadocs_cloc_metrics) do
      primary_key :id
      foreign_key :pod_id, :pods, :null => false, :key => [:id]

      String :language, :null => true
      Integer :comments, :null => true
      Integer :files, :null => true
    end
  end
end
