require_relative "bot"

class Initializer

  def initialize scenario_name
    init_db
    load_scenarios

    bot = Bot.new(scenario_name)
    bot.talk
  end

  private

  def init_db
    require "active_record"

    ActiveRecord::Base.establish_connection(
        :adapter => 'sqlite3',
        :database => 'chatbot.db'
    )

    require_relative "db/schema"

    require_relative "models/line"
    require_relative "models/user"
  end

  def load_scenarios
    Dir[File.dirname(__FILE__) + "/scenarios/*.rb"].each {|file| require file }
  end

end
