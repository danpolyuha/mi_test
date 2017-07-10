require_relative "core/processor"

class Bot

  def initialize scenario_name
    scenario = resolve_scenario(scenario_name)
    self.processor = Processor.new(scenario)
  end

  def talk
    text = processor.current_text
    while text do
      puts text
      reply = normalize_reply(gets)
      text = processor.reply(reply)
    end
  end

  private

  attr_accessor :processor

  def resolve_scenario name
    Scenarios.send(name)
  end

  def normalize_reply string
    string.chomp
  end

end
