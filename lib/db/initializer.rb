require "active_record"

ActiveRecord::Base.establish_connection(
    :adapter  => 'sqlite3',
    :database => 'chatbot.db'
)

require_relative "schema"

require_relative "../models/line"
require_relative "../models/user"
