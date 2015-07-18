Sequel.migration do
  change do
    alter_table(:cocoadocs_pod_metrics) do
      rename_column :changelog_url, :rendered_changelog_url
    end
  end
end
