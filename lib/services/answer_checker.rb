class AnswerChecker

  def initialize answer_pattern:, user:
    self.answer_pattern = answer_pattern
    self.user = user
  end

  def pattern
    type = pattern_type
    method = extractor_method_name(type)
    return send(method) if extractor_exists?(method)

    raise RuntimeError, "#{type} is invalid answer pattern type."
  end

  def acceptable_answer? answer
    answer =~ pattern
  end

  private

  attr_accessor :answer_pattern, :user

  def pattern_type
    @pattern_type ||= answer_pattern.class.name.downcase
  end

  def extractor_method_name type
    "extract_from_#{type}"
  end

  def extractor_exists?(method)
    respond_to?(method, true)
  end

  # extractors

  def extract_from_regexp
    answer_pattern
  end

  def extract_from_proc
    answer_pattern.call(user)
  end

end
