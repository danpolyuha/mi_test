require_relative "config"
require_relative "bot"

class Initializer

  def self.go scenario_name
    load_bundle

    init_db
    load_models
    load_scenarios

    bot = Bot.new(scenario_name)
    bot.talk
  end

  private

  def self.load_bundle
    require "bundler/setup"
    Bundler.require(:default)
  end

  def self.init_db
    ActiveRecord::Base.establish_connection(
        :adapter => 'sqlite3',
        :database => Config::DATABASE_NAME
    )

    load_schema
  end

  def self.load_schema
    require_relative "db/schema"
  end

  def self.load_models
    load_folder "models"
  end

  def self.load_scenarios
    load_folder "scenarios"
  end

  def self.load_folder folder
    current_dir = File.dirname(__FILE__)
    mask = "*.rb"
    path = File.join(current_dir, folder, mask)
    Dir[path].each {|file| require file }
  end

end
