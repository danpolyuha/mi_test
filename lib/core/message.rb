require_relative "services/reply_checker"

class Message

  attr_accessor :next_message_resolver

  def initialize text_resolver:, reply_pattern_resolver: nil, assigner_resolver: nil, user:
    self.text_resolver = text_resolver
    self.reply_pattern_resolver = reply_pattern_resolver
    self.assigner_resolver = assigner_resolver
    self.user = user
  end

  def get_text
    text_resolver.call(user)
  end

  def process_reply reply
    return reply_checker.reply_format_failure unless reply_checker.acceptable_reply?(reply)

    assign_data(reply)
    Rezult.success(next_message: get_next_message)
  end

  private

  attr_accessor :text_resolver, :reply_pattern_resolver, :assigner_resolver, :flow, :user

  def assign_data reply
    assigner_resolver&.call(user, reply)
    user.save
    user.add_line(reply)
  end

  def get_next_message
    next_message_resolver&.call(user)
  end

  def reply_checker
    @reply_checker ||= ReplyChecker.new(reply_pattern_resolver, user)
  end

end
