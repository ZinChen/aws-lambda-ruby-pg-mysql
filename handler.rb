require 'pg'
require 'mysql2'

def run(event:, context:)
  {
    postgres_client_version: PG.library_version,
    mysql_client_version: Mysql2::VERSION,
  }
end
