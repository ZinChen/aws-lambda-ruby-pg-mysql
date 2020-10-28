require 'pg'
require 'mysql2'
require 'nokogiri'

def run(event:, context:)
  {
    postgres_client_version: PG.library_version,
    mysql_client_version: Mysql2::VERSION,
    nokogiri_version: Nokogiri::VERSION
  }
end
