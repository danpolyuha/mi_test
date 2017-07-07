require 'rezult'

class Message

  def initialize text_pattern:, answer_pattern:
    self.text_pattern = text_pattern
    self.answer_pattern = answer_pattern
  end

  def process_answer answer
    return Rezult.fail(answer_format_mismatch_message) unless acceptable_answer?(answer)
  end

  private

  attr_accessor :text_pattern, :answer_pattern

  def acceptable_answer? answer
    answer =~ answer_pattern
  end

  def answer_format_mismatch_message
    "Provided answer can not be accepted. Please follow answer format: #{answer_pattern.inspect}"
  end

end
