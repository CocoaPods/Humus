Sequel.migration do
  change do
    create_table(:cocoadocs_pod_metrics) do
      primary_key :id
      foreign_key :pod_id, :pods, :null => false, :key => [:id]

      Integer :download_size, :null => true

      Integer :total_files, :null => true
      Integer :total_comments, :null => true
      Integer :total_lines_of_code, :null => true

      Integer :doc_percent, :null => true
      Integer :readme_complexity, :null => true
      DateTime :initial_commit_date, :null => true
      String :rendered_readme_url, :null => true

      Integer :not_found, :default => 0

      DateTime :created_at
      DateTime :updated_at
    end
    
    create_table(:cocoadocs_cloc_metrics) do
      primary_key :id
      foreign_key :pod_id, :pods, :null => false, :key => [:id]
      
      String :language, :null => true
      Integer :comments, :null => true
      Integer :files, :null => true      
    end
  end
end
