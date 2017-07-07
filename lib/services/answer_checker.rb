class AnswerChecker

  def initialize answer_pattern_template:, user:
    self.answer_pattern_template = answer_pattern_template
    self.user = user
  end

  def answer_pattern
    method = extractor_method_name(template_type)
    return send(method) if extractor_exists?(method)

    raise RuntimeError, "#{template_type} is invalid answer pattern template type."
  end

  def acceptable_answer? answer
    answer =~ answer_pattern
  end

  private

  attr_accessor :answer_pattern_template, :user

  def template_type
    @template_type ||= answer_pattern_template.class.name.downcase
  end

  def extractor_method_name type
    "extract_from_#{type}"
  end

  def extractor_exists?(method)
    respond_to?(method, true)
  end

  # extractors

  def extract_from_regexp
    answer_pattern_template
  end

  def extract_from_proc
    answer_pattern_template.call(user)
  end

end
