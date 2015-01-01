Sequel.migration do
  change do
    alter_table(:cocoadocs_cloc_metrics) do
      add_column :lines_of_code, Integer, :null => true
    end
  end
end
