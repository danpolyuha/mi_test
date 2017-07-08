# temporary
require "ostruct"
class User < OpenStruct
  def add_message m
    @m = m
  end

  def last_message
    @m
  end
end
# /temporary

FactoryGirl.define do

  factory :user do
    name "John"
    contact_method "phone"
    phone "+12345"
    email "john@email.com"
  end

end
