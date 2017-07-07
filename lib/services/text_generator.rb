class TextGenerator

  def initialize text_template:, user:
    self.text_template = text_template
    self.user = user
  end

  def generate
    method = generator_method_name(template_type)
    return send(method) if generator_exists?(method)

    raise RuntimeError, "#{template_type} is invalid message text template type."
  end

  private

  attr_accessor :text_template, :user

  def template_type
    @template_type ||= text_template.class.name.downcase
  end

  def generator_method_name(type)
    "generate_for_#{type}"
  end

  def generator_exists?(method)
    respond_to?(method, true)
  end

  # generators

  def generate_for_string
    text_template
  end

  def generate_for_proc
    text_template.call(user)
  end

end
