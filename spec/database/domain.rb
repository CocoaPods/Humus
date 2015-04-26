# Defines the domain.
#
Object.send :remove_const, :Domain if defined? Domain
Domain = Flounder.domain(DB) do |dom|
  dom.entity(:commits, :commit, 'commits')
  dom.entity(:pods, :pod, 'pods')
  dom.entity(:versions, :version, 'pod_versions')
  
  dom.entity(:owners_pods, :owners_pod, 'owners_pods')
end

# Define all tables as top-level methods on Domain.
#
Domain.entities.each do |entity|
  Domain.define_singleton_method entity.name do
    entity
  end
end
