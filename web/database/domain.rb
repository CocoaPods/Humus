# Defines the domain.
#
Domain = Flounder.domain(DB) do |dom|
  dom.entity(:schema_info, :schema_info, 'schema_info')
  dom.entity(:schema_info_metrics, :schema_info_metric, 'schema_info_metrics')
  
  dom.entity(:tables, :table, 'tables')
  
  # Add all tables.
  dom[:tables].where(table_schema: 'public').each do |table|
    name = table.table_name
    dom.entity(name.to_sym, name.to_sym, name)
  end
end

# Define all tables as top-level methods on Domain.
#
Domain.entities.each do |entity|
  Domain.define_singleton_method entity.name do
    entity
  end
end
