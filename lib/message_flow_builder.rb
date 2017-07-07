require "message"

class MessageFlowBuilder

  def initialize user, &block
    self.messages = {}
    self.user = user
    instance_eval(&block)
  end

  def first_message
    messages.values.first
  end

  private

  attr_accessor :user, :messages

  def message key:, text:, answer_pattern: nil, assigner: nil
    message = Message.new text_template: text,
                          answer_pattern_template: answer_pattern,
                          assigner: assigner,
                          user: user
    messages[key] = message
  end

  def flow structure
    structure.each do |message, result|
      messages[message].add_to_flow(/.+/ => result)
    end
  end

end
