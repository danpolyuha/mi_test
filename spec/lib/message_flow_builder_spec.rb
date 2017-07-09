require "message_flow_builder"

RSpec.describe MessageFlowBuilder do

  let(:builder) do
    described_class.new(user, &scenario)
  end

  let(:user) { create(:user, name: "John") }

  describe "DSL parsing" do

    context "when text is string" do
      let(:scenario) { ->{
        message :message1,
                text: "static text"
      }}

      it "creates message with corresponding text" do
        expect(builder.first_message.get_text).to eq("static text")
      end
    end

    context "when text is proc" do
      let(:scenario) { ->{
          message :message1,
                  text: ->(user) { "Paul and #{user.name}" }
      }}

      it "creates message that correctly resolves text" do
        expect(builder.first_message.get_text).to eq("Paul and John")
      end
    end

    context "when answer pattern is regexp" do
      let(:scenario) { ->{
        message :message1,
                text: "hello",
                answer_pattern: /^yes|no$/
      }}

      it "creates message with corresponding answer pattern" do
        expect(builder.first_message.process_answer("yes").success?).to be_truthy
        expect(builder.first_message.process_answer("maybe").success?).to be_falsey
      end
    end

    context "when answer pattern is proc" do
      let(:scenario) { ->{
        message :message1,
                text: "hello",
                answer_pattern: ->(user) { /^Paul|#{user.name}$/ }
      }}

      it "creates message with corresponding answer pattern" do
        expect(builder.first_message.process_answer("John").success?).to be_truthy
        expect(builder.first_message.process_answer("George").success?).to be_falsey
      end
    end

    context "when assigner is symbol" do
      let(:scenario) { ->{
        message :message1,
                text: "hello",
                assigner: :name
      }}

      it "assigns answer to corresponding attribute" do
        expect{builder.first_message.process_answer("George")}.to change{user.name}.from("John").to("George")
      end
    end

    context "when assigner is proc" do
      let(:scenario) { ->{
        message :message1,
                text: "hello",
                assigner: ->(user, answer) { user.name = answer }
      }}

      it "assigns answer to corresponding attribute" do
        expect{builder.first_message.process_answer("George")}.to change{user.name}.from("John").to("George")
      end
    end

    context "when next_message is message key" do
      let(:scenario) { ->{
        message :message1,
                text: "hello",
                next_message: :message2

        message :message2,
                text: "good bye"
      }}

      it "creates and correctly assigns next message" do
        next_message = builder.first_message.process_answer("hi").next_message
        expect(next_message.get_text).to eq("good bye")
      end
    end

    context "when next_message is wrong message key" do
      let(:scenario) { ->{
        message :message1,
                text: "hello",
                next_message: :message2
      }}

      it "raises exception" do
        expect{builder.first_message.process_answer("hi").next_message}.to raise_error(RuntimeError)
      end
    end

    context "when next_message is proc" do
      let(:scenario) { ->{
        message :message1,
                text: "hello",
                next_message: ->(user){user.name.downcase.to_sym}

        message :john,
                text: "good bye"
      }}

      it "creates and correctly assigns next message" do
        next_message = builder.first_message.process_answer("hi").next_message
        expect(next_message.get_text).to eq("good bye")
      end
    end

  end

end
