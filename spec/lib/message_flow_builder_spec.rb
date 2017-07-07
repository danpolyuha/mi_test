require "message_flow_builder"

RSpec.describe MessageFlowBuilder do

  let(:builder) do
    described_class.new(build(:user)) do

      message key: :message1,
              text: "Welcome!"

      message key: :message2,
              text: "Input your phone",
              answer_pattern: /\+?\d+/,
              assigner: :phone

      flow message1: :message2

    end
  end

  describe "#first_message" do
    it "correctly returns first message" do
      expect(builder.first_message.get_text).to eq("Welcome!")
    end
  end

end
