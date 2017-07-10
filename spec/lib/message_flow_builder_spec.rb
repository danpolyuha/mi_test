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

    context "when reply pattern is regexp" do
      let(:scenario) { ->{
        message :message1,
                text: "hello",
                reply_pattern: /^yes|no$/
      }}

      it "creates message with corresponding reply pattern" do
        expect(builder.first_message.process_reply("yes").success?).to be_truthy
        expect(builder.first_message.process_reply("maybe").success?).to be_falsey
      end
    end

    context "when reply pattern is proc" do
      let(:scenario) { ->{
        message :message1,
                text: "hello",
                reply_pattern: ->(user) { /^Paul|#{user.name}$/ }
      }}

      it "creates message with corresponding reply pattern" do
        expect(builder.first_message.process_reply("John").success?).to be_truthy
        expect(builder.first_message.process_reply("George").success?).to be_falsey
      end
    end

    context "when assigner is symbol" do
      let(:scenario) { ->{
        message :message1,
                text: "hello",
                assigner: :name
      }}

      it "assigns reply to corresponding attribute" do
        expect{builder.first_message.process_reply("George")}.to change{user.name}.from("John").to("George")
      end
    end

    context "when assigner is proc" do
      let(:scenario) { ->{
        message :message1,
                text: "hello",
                assigner: ->(user, reply) { user.name = reply }
      }}

      it "assigns reply to corresponding attribute" do
        expect{builder.first_message.process_reply("George")}.to change{user.name}.from("John").to("George")
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
        next_message = builder.first_message.process_reply("hi").next_message
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
        expect{builder.first_message.process_reply("hi").next_message}.to raise_error(RuntimeError)
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
        next_message = builder.first_message.process_reply("hi").next_message
        expect(next_message.get_text).to eq("good bye")
      end
    end

    context "when next_message proc returns wrong key" do
      let(:scenario) { ->{
        message :message1,
                text: "hello",
                next_message: ->(user){ :jack }

        message :john,
                text: "good bye"
      }}

      it "creates and correctly assigns next message" do
        expect{builder.first_message.process_reply("hi").next_message}.to raise_error(RuntimeError)
      end
    end

  end

end
