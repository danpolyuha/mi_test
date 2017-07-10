require_relative "message"
require_relative "wrappers/caller"
require_relative "wrappers/assigner"
require_relative "services/next_messages_assigner"

class MessageFlowBuilder

  def initialize user, &block
    self.messages = {}
    self.user = user
    self.flow = {}
    instance_exec(&block)
    next_messages_assigner.assign
  end

  def first_message
    messages.values.first
  end

  private

  attr_accessor :user, :messages, :flow

  def message key, text:, reply_pattern: nil, assigner: nil, next_message: nil
    messages[key] = create_message(text, reply_pattern, assigner)
    flow[key] = next_message if next_message
  end

  def create_message text, reply_pattern, assigner
    Message.new text_resolver: Caller.new(text),
                reply_pattern_resolver: reply_pattern ? Caller.new(reply_pattern) : nil,
                assigner_resolver: assigner ? Assigner.new(assigner) : nil,
                user: user
  end

  def next_messages_assigner
    @next_messages_assigner ||= NextMessagesAssigner.new(flow, messages)
  end

end
