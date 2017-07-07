require "services/next_message_resolver"

RSpec.describe NextMessageResolver do

  let(:resolver) { described_class.new(flow: flow, user: build(:user, name: name)) }
  let(:name) { "Paul" }

  let(:messages) { build_list(:message, 2) }
  let(:flow) { {"answer1" => messages[0],
                "answer2" => ->(user) { user.name == name ? messages[1] : "blabla" },
                "answer3" => 45} }

  describe "#get_next_message" do
    it "raises exception when answer is not recognized" do
      expect{resolver.get_next_message(123)}.to raise_error(RuntimeError)
    end

    it "returns corresponding message when next message is strictly defined" do
      expect(resolver.get_next_message("answer1")).to eq(messages[0])
    end

    it "returns correct message when flow has complex logic" do
      expect(resolver.get_next_message("answer2")).to eq(messages[1])
    end

    it "raises exception when flow item type is not supported" do
      expect{resolver.get_next_message("answer3")}.to raise_error(RuntimeError)
    end
  end

end
