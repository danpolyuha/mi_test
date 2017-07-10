class ReplyChecker

  def initialize reply_pattern_resolver, user
    self.reply_pattern_resolver = reply_pattern_resolver
    self.user = user
  end

  def acceptable_reply? reply
    return true unless pattern = resolve_reply_pattern

    check_pattern(pattern)
    pattern.match?(reply)
  end

  def reply_format_failure
    Rezult.fail(format_error_message)
  end

  private

  attr_accessor :reply_pattern_resolver, :user

  def resolve_reply_pattern
    reply_pattern_resolver&.call(user)
  end

  def check_pattern(pattern)
    raise RuntimeError, "Reply pattern must respond do 'match?'" unless correct_pattern?(pattern)
  end

  def correct_pattern?(pattern)
    pattern.respond_to?(:match?)
  end

  def format_error_message
    pattern = resolve_reply_pattern
    "Provided reply can not be accepted. Please follow reply format: #{pattern&.inspect}"
  end

end
