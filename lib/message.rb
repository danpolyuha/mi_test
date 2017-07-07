require "rezult"
require "services/text_generator"
require "services/answer_checker"
require "services/data_assigner"

class Message

  def initialize text_template:, answer_pattern_template:, assigner:, user:
    self.text_template = text_template
    self.answer_pattern_template = answer_pattern_template
    self.assigner = assigner
    self.user = user
  end

  def get_text
    text_generator.generate
  end

  def process_answer answer
    return Rezult.fail(answer_format_mismatch_message) unless acceptable_answer?(answer)

    data_assigner.assign(answer)
  end

  private

  attr_accessor :text_template, :answer_pattern_template, :assigner, :user

  def acceptable_answer? answer
    answer_checker.acceptable_answer?(answer)
  end

  def answer_format_mismatch_message
    "Provided answer can not be accepted. Please follow answer format: #{answer_checker.answer_pattern.inspect}"
  end

  def text_generator
    @text_generator ||= TextGenerator.new(text_template: text_template, user: user)
  end

  def answer_checker
    @answer_checker ||= AnswerChecker.new(answer_pattern_template: answer_pattern_template, user: user)
  end

  def data_assigner
    @data_assigner ||= DataAssigner.new(assigner: assigner, user: user)
  end

end
