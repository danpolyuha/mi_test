require_relative "message_flow_builder"

class Processor

  def initialize scenario
    self.user = User.create
    flow_builder = MessageFlowBuilder.new(user, &scenario)
    self.current_message = flow_builder.first_message
  end

  def current_text
    current_message.get_text
  end

  def reply text
    result = current_message.process_reply(text)
    if result.success?
      self.current_message = result.next_message
      current_message&.get_text
    else
      result.error_message
    end
  end

  private

  attr_accessor :user
  attr_accessor :current_message

end
