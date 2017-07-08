require "rezult"

class Message

  attr_accessor :next_message_resolver

  def initialize text_resolver:, answer_pattern_resolver: nil, assigner_resolver: nil, user:
    self.text_resolver = text_resolver
    self.answer_pattern_resolver = answer_pattern_resolver
    self.assigner_resolver = assigner_resolver
    self.user = user
  end

  def get_text
    text_resolver.call(user)
  end

  def process_answer answer
    answer_pattern = get_answer_pattern
    return answer_format_failure(answer_pattern) unless acceptable_answer?(answer, answer_pattern)

    assign_data(answer)
    Rezult.success(next_message: get_next_message)
  end

  private

  attr_accessor :text_resolver, :answer_pattern_resolver, :assigner_resolver, :flow, :user

  def get_answer_pattern
    answer_pattern_resolver&.call(user)
  end

  def answer_format_failure pattern
    Rezult.fail "Provided answer can not be accepted. Please follow answer format: #{pattern.inspect}"
  end

  def acceptable_answer? answer, pattern
    return true unless pattern

    raise RuntimeError, "Answer pattern must respond do 'match?'" unless pattern.respond_to?(:match?)

    pattern.match?(answer)
  end

  def assign_data answer
    assigner_resolver&.call(user, answer)
    user.add_message(answer)
  end

  def get_next_message
    next_message_resolver&.call(user)
  end

end
