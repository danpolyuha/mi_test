require "active_record"

ActiveRecord::Base.establish_connection(
    :adapter  => 'sqlite3',
    :database => ':memory:'
)

require "db/schema"

require "models/line"
require "models/user"
