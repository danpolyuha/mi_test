require_relative "message_flow_builder"
require_relative "services/lines_saver"

class Processor

  def initialize scenario
    create_user
    build_messages_flow(scenario)
    lines_saver.bot_line(current_text)
  end

  def current_text
    current_message.get_text
  end

  def reply text
    lines_saver.user_line(text)
    bot_text = process_reply(text)
    lines_saver.bot_line(bot_text)
    bot_text
  end

  private

  attr_accessor :user
  attr_accessor :current_message

  def create_user
    self.user = User.create
  end

  def build_messages_flow scenario
    flow_builder = MessageFlowBuilder.new(user, &scenario)
    self.current_message = flow_builder.first_message
  end

  def process_reply text
    result = current_message.process_reply(text)
    if result.success?
      self.current_message = result.next_message
      bot_text = current_message&.get_text
    else
      bot_text = result.error_message
    end

    bot_text
  end

  def lines_saver
    @lines_saver ||= LinesSaver.new(user)
  end

end
