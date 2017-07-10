require_relative "../wrappers/caller"

class NextMessagesAssigner

  def initialize flow, messages
    self.flow = flow
    self.messages = messages
  end

  def assign
    flow.each do |message_key, next_message_key|
      message = messages[message_key]
      next_message = next_message_by_key(next_message_key)
      message.next_message_resolver = Caller.new(next_message)
    end
  end

  private

  attr_accessor :flow, :messages

  def next_message_by_key key
    key.is_a?(Proc) ? wrap_next_message_proc(key) : find_by_key(key)
  end

  def wrap_next_message_proc proc
    ->(user) do
      key = proc.call(user)
      key ? find_by_key(key) : nil
    end
  end

  def find_by_key key
    next_message = messages[key]
    raise_incorrect_next_message(key) unless next_message
    next_message
  end

  def raise_incorrect_next_message(key)
    raise RuntimeError, "#{key} is incorrect next message key"
  end

end
