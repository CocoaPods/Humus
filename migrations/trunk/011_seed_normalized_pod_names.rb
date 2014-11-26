Sequel.migration do
  transaction
  up do
    DB[:pods].each do |pod|
      pod[:normalized_name] = pod[:name].downcase
      pod[:updated_at] = Time.now
      DB[:pods].update(pod)
    end
  end
end
