class Caller

  def initialize callee
    self.callee = normalize_callee(callee)
  end

  def call *params
    callee.call(*params)
  end

  protected

  def wrap_into_proc object
    ->(*){object}
  end

  private

  attr_accessor :callee

  def normalize_callee callee
    callee.is_a?(Proc) ? callee : wrap_into_proc(callee)
  end

end
