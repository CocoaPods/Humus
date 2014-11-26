# Defines the domain.
#
Domain = Flounder.domain(DB) do |dom|
  dom.entity(:schema_info, :schema_info, 'schema_info')
  dom.entity(:schema_info_metrics, :schema_info_metrics, 'schema_info_metrics')
end

# Define all tables as top-level methods on Domain.
#
Domain.entities.each do |entity|
  Domain.define_singleton_method entity.name do
    entity
  end
end
