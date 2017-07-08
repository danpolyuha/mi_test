require "message_flow_builder"

RSpec.describe MessageFlowBuilder do

  let(:builder) do
    described_class.new(user, &scenario)
  end

  let(:user) { build(:user, name: "John") }

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

  end

end
