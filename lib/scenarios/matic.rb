module Scenarios

  def self.matic
    ->{
      message :start,
              text: "I can help you with answers to all your related questions and help to find a great job!",
              reply_pattern: /^let's talk$/i,
              next_message: :name_input

      message :name_input,
              text: "Please enter your name:",
              assigner: :name,
              next_message: :contact_method

      message :contact_method,
              text: ->(user) { "Hello #{user.name}, how can we reach out to you?" },
              reply_pattern: /^phone|email|i don't want to be contacted$/i,
              assigner: :contact_method,
              next_message: ->(user) do
                user.contact_method.downcase.to_sym
              end

      message :phone,
              text: "Please type your phone number:",
              reply_pattern: /^\+?\d+$/,
              assigner: :phone,
              next_message: :contact_time

      message :contact_time,
              text: "What is the best time we can reach out to you?",
              reply_pattern: /^asap|morning|afternoon|evening$/i,
              assigner: :contact_time,
              next_message: :contact_confirmation

      message :contact_confirmation,
              text: ->(user){ "We are going to contact you using #{user.contact_method}: #{user.contact_method == "phone" ? user.phone : user.email}" },
              reply_pattern: ->(user) { /^yes, please|sorry, wrong #{user.contact_method}$/i },
              next_message: ->(user) do
                return :email if user.last_line_text =~ /email/i
                return :phone if user.last_line_text =~ /phone/i
              end

      message :email,
              text: "Please type your email address:",
              reply_pattern: /^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$/i,
              assigner: :email,
              next_message: :contact_confirmation

      message :"i don't want to be contacted",
              text: "Sad to hear that. Whenever you change your mind - feel free to send me a message."
    }
  end

end
