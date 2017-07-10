require_relative "message_flow_builder"

class Processor

  def initialize scenario
    self.user = User.create
    flow_builder = MessageFlowBuilder.new(user, &scenario)
    self.current_message = flow_builder.first_message
    add_bot_line(current_text)
  end

  def current_text
    current_message.get_text
  end

  def reply text
    add_user_line(text)

    result = current_message.process_reply(text)
    if result.success?
      self.current_message = result.next_message
      bot_text = current_message&.get_text
    else
      bot_text = result.error_message
    end

    add_bot_line(bot_text)
    bot_text
  end

  private

  attr_accessor :user
  attr_accessor :current_message

  def add_user_line text
    if text
      text = format_user_line(text)
      user.add_line(text)
    end
  end

  def add_bot_line text
    if text
      text = format_bot_line(text)
      user.add_line(text)
    end
  end

  def format_user_line text
    "USER: #{text}"
  end

  def format_bot_line text
    "BOT: #{text}"
  end

end
