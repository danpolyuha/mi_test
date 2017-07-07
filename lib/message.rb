require "rezult"
require "services/text_generator"
require "services/answer_checker"

class Message

  def initialize text_template:, answer_pattern:, user:
    self.text_template = text_template
    self.answer_pattern = answer_pattern
    self.user = user
  end

  def get_text
    text_generator.generate
  end

  def process_answer answer
    return Rezult.fail(answer_format_mismatch_message) unless acceptable_answer?(answer)
  end

  private

  attr_accessor :text_template, :answer_pattern, :user

  def acceptable_answer? answer
    answer_checker.acceptable_answer?(answer)
  end

  def answer_format_mismatch_message
    "Provided answer can not be accepted. Please follow answer format: #{answer_checker.pattern.inspect}"
  end

  def text_generator
    @text_generator ||= TextGenerator.new(text_template: text_template, user: user)
  end

  def answer_checker
    @answer_checker ||= AnswerChecker.new(answer_pattern: answer_pattern, user: user)
  end

end
