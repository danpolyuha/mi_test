FactoryGirl.define do

  factory :message do
    text_template "input your phone"
    answer_pattern_template(/^\+?\d+$/)
    assigner :phone
    user

    initialize_with{ new(text_template: text_template,
                         answer_pattern_template: answer_pattern_template,
                         assigner: assigner,
                         user: user
    )}
  end

end
