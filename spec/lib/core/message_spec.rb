require "core/message"
require "core/wrappers/caller"
require "core/wrappers/assigner"

RSpec.describe Message do

  let(:message) { described_class.new(
                        text_resolver: text_resolver,
                        reply_pattern_resolver: reply_pattern_resolver,
                        assigner_resolver: assigner_resolver,
                        user: user) }

  let(:text) { "blablabla" }
  let(:text_resolver) { Caller.new(text) }
  let(:reply_pattern_resolver) { nil }
  let(:assigner_resolver) { nil }
  let(:user) { create(:user) }

  describe "#get_text" do
    it "returns generated text" do
      expect(message.get_text).to eq(text)
    end
  end

  describe "#process_reply" do

    context "when reply doesn't meet pattern" do
      let(:pattern) { /[A-Za-z]+/ }
      let(:reply_pattern_resolver) { Caller.new(pattern) }
      let(:result) { message.process_reply("1234") }

      it "returns failure" do
        expect(result.success?).to be_falsey
      end

      it "returns error message" do
        expect(result.error_message).to include(pattern.inspect)
      end
    end

    context "when reply_pattern has unacceptable type" do
      let(:reply_pattern_resolver) { Caller.new(55) }

      it "raises exception" do
        expect{message.process_reply("1234")}.to raise_error(RuntimeError)
      end
    end

    context "when reply is fine" do
      let(:name) { "Paul" }
      let(:assigner_resolver) { Assigner.new(:name) }

      it "properly assigns data to user" do
        expect{message.process_reply(name)}.to change{user.name}.to(name)
      end

      it "adds message to user messages" do
        message.process_reply(name)
        expect(user.last_line_text).to eq(name)
      end

      it "returns next message in flow" do
        next_message = double
        message.next_message_resolver = Caller.new(next_message)
        expect(message.process_reply(name).next_message).to eq(next_message)
      end
    end

  end
end
