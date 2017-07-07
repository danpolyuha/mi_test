class MessageTextGenerator

  def initialize text_template:, user:
    @text_template = text_template
    @user = user
  end

  def generate
    type = @text_template.class.name.downcase
    method = "generate_for_#{type}"
    return send(method) if respond_to?(method, true)

    raise RuntimeError, "#{type} is invalid message text template type."
  end

  private

  def generate_for_string
    @text_template
  end

  def generate_for_proc
    @text_template.call(@user)
  end

end
