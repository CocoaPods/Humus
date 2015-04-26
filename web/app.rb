Bundler.require(*[:default, :web, :database, ENV['RACK_ENV'].to_sym].compact)

require 'json'
require 'sinatra/base'

require './web/database/db'
require './web/database/domain'

class Humus < Sinatra::Base
  def table_info
    table_info = {
      calculated_at: Time.now,
    }
    DB.with_connection do |conn|
      table_info[:total_bytes] = conn.exec("SELECT pg_database_size('#{conn.pg.db}');").values.flatten.first.to_i
      Domain.entities.each do |t|
        escaped_name = conn.quote_table_name(t.name)
        table_info[t.name] = {
          bytes: conn.exec("SELECT pg_total_relation_size('#{escaped_name}');",).values.flatten.first.to_i,
          count: conn.exec("SELECT count(*) FROM #{escaped_name};").values.flatten.first.to_i,
        }
      end
    end
    table_info
  end

  get "/api/v1/status/?#{ENV['ACCESS_TOKEN']}" do
    {
      tables: table_info,
      versions: {
        schema_info: Domain.schema_info.first.version,
        schema_info_metrics: Domain.schema_info_metrics.first.version,
      },
    }.to_json
  end
end
