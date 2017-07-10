require "core/services/next_messages_assigner"
require "core/message"

RSpec.describe NextMessagesAssigner do

  let(:assigner) { described_class.new(flow, messages) }

  let(:user) { build(:user) }
  let(:message1) { Message.new(text_resolver: Caller.new("hi"), user: user) }
  let(:message2) { Message.new(text_resolver: Caller.new("bye"), user: user) }

  let(:messages) { { m1: message1, m2: message2 } }

  describe "#assign" do

    context "when next message key is proc returning correct key" do
      let(:flow) { { m1: ->(user) { :m2 } } }

      it "correctly assigns next message" do
        assigner.assign
        expect(message1.process_reply("hi").next_message).to eq(message2)
      end
    end

    context "when next message key is proc returning incorrect key" do
      let(:flow) { { m1: ->(user) { :m3 } } }

      it "creates proc raising exception" do
        assigner.assign
        expect{message1.process_reply("hi").next_message}.to raise_error(RuntimeError)
      end
    end

    context "when next message key is correct symbol" do
      let(:flow) { { m1: :m2 } }

      it "correctly assigns next message" do
        assigner.assign
        expect(message1.process_reply("hi").next_message).to eq(message2)
      end
    end

    context "when next message key is incorrect symbol" do
      let(:flow) { { m1: :m3 } }

      it "raises exception" do
        expect{assigner.assign}.to raise_error(RuntimeError)
      end
    end

  end

end
