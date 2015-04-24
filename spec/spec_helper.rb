# Load DB.
#
if ENV['LOAD_TEST_DB']
  `pg_restore --verbose --clean --no-acl --no-owner -h localhost -d trunk_cocoapods_org_test spec/trunk.dump`
end

Bundler.require(:database, :test)

require File.expand_path '../database/db', __FILE__
require File.expand_path '../database/domain', __FILE__