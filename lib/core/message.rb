require "rezult"

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
    reply_pattern = get_reply_pattern
    return reply_format_failure(reply_pattern) unless acceptable_reply?(reply, reply_pattern)

    assign_data(reply)
    Rezult.success(next_message: get_next_message)
  end

  private

  attr_accessor :text_resolver, :reply_pattern_resolver, :assigner_resolver, :flow, :user

  def get_reply_pattern
    reply_pattern_resolver&.call(user)
  end

  def reply_format_failure pattern
    Rezult.fail "Provided reply can not be accepted. Please follow reply format: #{pattern.inspect}"
  end

  def acceptable_reply? reply, pattern
    return true unless pattern

    raise RuntimeError, "Reply pattern must respond do 'match?'" unless pattern.respond_to?(:match?)

    pattern.match?(reply)
  end

  def assign_data reply
    assigner_resolver&.call(user, reply)
    user.save
    user.add_line(reply)
  end

  def get_next_message
    next_message_resolver&.call(user)
  end

end
