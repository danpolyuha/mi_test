module Scenarios

  def self.matic
    ->{
      message :start,
              text: "I can help you with answers to all your related questions and help to find a great job!",
              reply_pattern: /let's talk/,
              next_message: :name_input

      message :name_input,
              text: "Please enter your name:",
              assigner: :name,
              next_message: :contact_method

      message :contact_method,
              text: ->(user) { "Hello #{user.name}, how can we reach out to you?" },
              reply_pattern: /phone|email|i don't want to be contacted/,
              assigner: ->(user, reply) { user.contact_method = reply if ["phone", "email"].include?(reply) },
              next_message: ->(user) do
                case user.contact_method
                  when "email"
                    :email
                  when "phone"
                    :phone
                  else
                    :failure
                end
              end

      message :phone,
              text: "Please type your phone number:",
              reply_pattern: /^\+?\d+$/,
              assigner: :phone,
              next_message: :contact_time

      message :contact_time,
              text: "What is the best time we can reach out to you?",
              reply_pattern: /asap|morning|afternoon|evening/,
              assigner: :contact_time,
              next_message: :contact_confirmation

      message :contact_confirmation,
              text: ->(user){ "We are going to contact you using #{user.contact_method}: #{user.contact_method == "phone" ? user.phone : user.email}" },
              reply_pattern: ->(user) { /yes, please|sorry, wrong #{user.contact_method}/ },
              next_message: ->(user) do
                return :email if user.last_line =~ /email/
                return :phone if user.last_line =~ /phone/
              end

      message :enail,
              text: "Please type your enail address:",
              reply_pattern: /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/,
              assigner: :email,
              next_message: :contact_confirmation

      message :failure,
              text: "Sad to hear that. Whenever you change your mind - feel free to send me a message."
    }
  end

end
