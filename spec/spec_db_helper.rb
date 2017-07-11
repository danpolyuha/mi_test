ActiveRecord::Base.establish_connection(
    :adapter  => 'sqlite3',
    :database => ':memory:'
)

require "db/schema"

# load models
current_dir = File.dirname(__FILE__)
Dir[File.join(current_dir, "../lib/models/*.rb")].each {|file| require file }
