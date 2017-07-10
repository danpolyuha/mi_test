module Scenarios

  def self.test
    ->{
      message :m1,
              text: "hello",
              assigner: :name
    }
  end

end
