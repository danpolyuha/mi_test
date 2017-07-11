# Test task for M. I. company

During implememtation of this project, I was keeping in mind two important points I wanted to achieve:
* structure of messages should be self-sufficient, meaning that a message object (representing a bot message in the chat) can decide where to pass execution by itself;
* DSL for building chat scenarios should be as compact as possible and, in the same time, fully functional, having possibility to describe everything scenario author needs.

So, here is the result of my work.

To prepare the environment, type:
```shell
gem install bundler
bundle install
```

To run the chatbot, type:

```shell
ruby chatbot.rb
```

The most important part from user perspective is DSL. It consists of `message` methods with parameters describing desired behavior. Here is a small example:

```ruby
->{
        message :message1,
                text: "Hello, what's your name?",
                reply_pattern: /^[a-z ]+$/i,
                assigner: :name,
                next_message: :message2

        message :message2,
                text: ->(user){ "Good bye, #{user.name}!" }
      }
```

The first argument to `message` is message key. It's needed for referencing.

`text` keyword argument is mandatory. It can be a simple object (converted to string afterwards) or lambda that returns text based on it's argument - `User` instance.

`reply_pattern` is a regular expression showing how user can reply. If user's reply doesn't match the pattern, bot tells user about it and asks to reply again. This parameter also can be a lambda with `user` parameter.

`assigner` represents a field of `User` instance to which user's reply will be assigned. It can also be a lambda receiving two parameters: `user` and `value`.

The last agrument is `next_message`. It contains key of the next message in the conversation. Of course, it can also be a lambda receiving `User` instance.

All these possibilities allow to describe flow of bot messages of needed complexity. Here is the original scenario created for the task:

```ruby
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
```

Each line of the chat is written into DB in a very simple form.

I've used a tiny gem of mine called `rezult` (https://github.com/danpolyuha/rezult) for managing returning values in some places, I believe this is a viable approach.
