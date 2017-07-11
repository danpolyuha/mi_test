require_relative "../wrappers/caller"

class NextMessagesAssigner

  def initialize flow, messages
    self.flow = flow
    self.messages = messages
  end

  def assign
    flow.each do |key, next_key|
      message = messages[key]
      next_message = normalize_next_message(next_key)
      message.next_message_resolver = Caller.new(next_message)
    end
  end

  private

  attr_accessor :flow, :messages

  def normalize_next_message key
    key.is_a?(Proc) ? wrap_next_message_proc(key) : find_by_key(key)
  end

  # Original proc returns message key. Let's wrap it to return message itself.
  def wrap_next_message_proc proc
    ->(user) do
      key = proc.call(user)
      key ? find_by_key(key) : nil
    end
  end

  def find_by_key key
    raise_incorrect_next_message(key) unless next_message = messages[key]
    next_message
  end

  def raise_incorrect_next_message(key)
    raise RuntimeError, "#{key} is incorrect next message key"
  end

end
