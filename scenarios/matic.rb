module Scenarios

  def self.matic
    ->{
      message :message1,
              text: "Hello!",
              next_message: :message2

      message :message2,
              text: "Good bye!"
    }
  end

end