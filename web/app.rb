Bundler.require(*[:default, :web, ENV['RACK_ENV'].to_sym].compact)

require 'json'
require 'sinatra/base'

require './web/database/db'
require './web/database/domain'

class Humus < Sinatra::Base
  get '/api/v1/status' do
    {
      versions: {
        schema_info: Domain.schema_info.first.version,
        schema_info_metrics: Domain.schema_info_metrics.first.version
      }
    }.to_json
  end
end