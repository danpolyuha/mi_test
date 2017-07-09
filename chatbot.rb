require_relative "lib/processor"

require_relative "lib/db/initializer"

require_relative "scenarios/matic"

processor = Processor.new(Scenarios.matic)

text = processor.current_text
while text do
  puts text
  reply = gets
  text = processor.reply(reply)
end
