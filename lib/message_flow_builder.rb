require_relative "message"
require_relative "services/caller"
require_relative "services/assigner"

class MessageFlowBuilder

  def initialize user, &block
    self.messages = {}
    self.user = user
    instance_exec(&block)
  end

  def first_message
    messages.values.first
  end

  private

  attr_accessor :user, :messages

  def message key, text:, answer_pattern: nil, assigner: nil
    messages[key] = create_message(text, answer_pattern, assigner)
  end

  def create_message text, answer_pattern, assigner
    Message.new text_resolver: Caller.new(text),
                answer_pattern_resolver: answer_pattern ? Caller.new(answer_pattern) : nil,
                assigner_resolver: assigner ? Assigner.new(assigner) : nil,
                user: user
  end

  # def generate_proc next_messages
  #   ->(user) do
  #     key = next_messages.call(user)
  #     messages[key]
  #   end
  # end
  #
end
