require "services/next_message_resolver"

RSpec.describe NextMessageResolver do

  let(:resolver) { described_class.new(flow: flow, user: user) }

  let(:user) { double(name: "John") }
  let(:message1) { double("class" => Message) }
  let(:message2) { double("class" => Message) }
  let(:message3) { double("class" => Message) }
  let(:answer1) { "answer1" }
  let(:answer2) { "answer2" }
  let(:answer3) { "answer3" }
  let(:flow) { {answer1 => message1,
                answer2 => ->(user) { user.name == "John" ? message2 : message3 },
                answer3 => 45} }

  describe "#get_next_message" do
    it "raises exception when answer is not recognized" do
      expect{resolver.get_next_message(123)}.to raise_error(RuntimeError)
    end

    it "returns corresponding message when next message is strictly defined" do
      expect(resolver.get_next_message(answer1)).to eq(message1)
    end

    it "returns correct message when flow has complex logic" do
      expect(resolver.get_next_message(answer2)).to eq(message2)
    end

    it "raises exception when flow item type is not supported" do
      expect{resolver.get_next_message(answer3)}.to raise_error(RuntimeError)
    end
  end

end
