require "rezult"
require "services/text_generator"
require "services/answer_checker"
require "services/data_assigner"
require "services/next_message_resolver"

class Message

  def initialize text_template:, answer_pattern_template:, assigner:, user:
    self.text_template = text_template
    self.answer_pattern_template = answer_pattern_template
    self.assigner = assigner
    self.user = user
    self.flow = {}
  end

  def get_text
    text_generator.generate
  end

  def process_answer answer
    return Rezult.fail(answer_format_mismatch_message) unless acceptable_answer?(answer)

    data_assigner.assign(answer)
    next_message = next_message_resolver.get_next_message(answer)
    Rezult.success(next_message: next_message)
  end

  def add_to_flow answer, item
    flow[answer] = item
  end

  private

  attr_accessor :text_template, :answer_pattern_template, :assigner, :flow, :user

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

  def next_message_resolver
    @next_message_resolver ||= NextMessageResolver.new(flow: flow, user: user)
  end

end
