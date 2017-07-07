class NextMessageResolver

  def initialize flow:, user:
    self.flow = flow
    self.user = user
  end

  def get_next_message answer
    next_message_template = flow[answer]
    raise RuntimeError, "'#{answer}' is not acceptable answer in this case." unless next_message_template

    type = template_type(next_message_template)
    method = resolver_method_name(type)
    return send(method, next_message_template) if resolver_exists?(method)

    raise RuntimeError, "#{type} is invalid flow item type."
  end

  private

  attr_accessor :flow, :user

  def template_type template
    template.class.name.downcase
  end

  def resolver_method_name type
    "resolve_with_#{type}"
  end

  def resolver_exists?(method)
    respond_to?(method, true)
  end

  # resolvers

  def resolve_with_message next_message_template
    next_message_template
  end

  def resolve_with_proc next_message_template
    next_message_template.call(user)
  end

end
