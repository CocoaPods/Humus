# -- General ------------------------------------------------------------------

ROOT = File.expand_path('../../', __FILE__)
$LOAD_PATH.unshift File.join(ROOT, 'lib')

ENV['RACK_ENV'] ||= 'production'
ENV['DATABASE_URL'] ||= "postgres://localhost/trunk_cocoapods_org_#{ENV['RACK_ENV']}"

# -- Database -----------------------------------------------------------------

require 'sequel'
require 'pg'

require 'logger'
DB = Sequel.connect(ENV['DATABASE_URL'], logger: Logger.new(STDOUT))
DB.timezone = :utc
Sequel.extension :core_extensions, :migration