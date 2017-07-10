require_relative "message"
require_relative "wrappers/caller"
require_relative "wrappers/assigner"

class MessageFlowBuilder

  def initialize user, &block
    self.messages = {}
    self.user = user
    self.flow = {}
    instance_exec(&block)
    assign_next_messages
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

  def assign_next_messages
    flow.each do |message_key, next_message_key|
      message = messages[message_key]
      next_message = next_message_by_key(next_message_key)
      message.next_message_resolver = Caller.new(next_message)
    end
  end

  def next_message_by_key key
    return wrap_next_message_proc(key) if key.is_a?(Proc)

    next_message = messages[key]
    raise RuntimeError, "#{key} is incorrect next message key" unless next_message

    next_message
  end

  def wrap_next_message_proc proc
    ->(user) do
      key = proc.call(user)
      return nil unless key
      return messages[key] if messages.has_key?(key)

      raise RuntimeError, "#{key} is incorrect next message key"
    end
  end

end
