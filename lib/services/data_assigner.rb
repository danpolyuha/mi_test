class DataAssigner

  def initialize assigner:, user:
    self.assigner = assigner
    self.user = user
  end

  def assign data
    method = assigner_method_name(assigner_type)
    return send(method, data) if assigner_exists?(method)

    raise RuntimeError, "#{assigner_type} is invalid assigner type."
  end

  private

  attr_accessor :assigner, :user

  def assigner_type
    @assigner_type ||= assigner.class.name.downcase
  end

  def assigner_method_name(type)
    "assign_with_#{type}"
  end

  def assigner_exists?(method)
    respond_to?(method, true)
  end

  # assigners

  def assign_with_symbol data
    method = "#{assigner}="
    user.send method, data
  end

  def assign_with_proc data
    assigner.call(data, user)
  end

end
