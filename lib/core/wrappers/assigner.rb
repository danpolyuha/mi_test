require_relative "caller"

class Assigner < Caller

  protected

  def wrap_into_proc object
    method_name = "#{object}="
    ->(user, value) { user.send(method_name, value) }
  end

end
