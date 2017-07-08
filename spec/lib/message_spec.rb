require "message"
require "services/caller"
require "services/assigner"

RSpec.describe Message do

  let(:message) { Message.new(
                        text_resolver: text_resolver,
                        answer_pattern_resolver: answer_pattern_resolver,
                        assigner_resolver: assigner_resolver,
                        user: user) }

  let(:text) { "blablabla" }
  let(:text_resolver) { Caller.new(text) }
  let(:answer_pattern_resolver) { nil }
  let(:assigner_resolver) { nil }
  let(:user) { build(:user) }

  describe "#get_text" do
    it "returns generated text" do
      expect(message.get_text).to eq(text)
    end
  end

  describe "#process_answer" do

    context "when answer doesn't meet pattern" do
      let(:pattern) { /[A-Za-z]+/ }
      let(:answer_pattern_resolver) { Caller.new(pattern) }
      let(:result) { message.process_answer("1234") }

      it "returns failure" do
        expect(result.success?).to be_falsey
      end

      it "returns error message" do
        expect(result.error_message).to include(pattern.inspect)
      end
    end

    context "when answer_pattern has unacceptable type" do
      let(:answer_pattern_resolver) { Caller.new(55) }

      it "raises exception" do
        expect{message.process_answer("1234")}.to raise_error(RuntimeError)
      end
    end

    context "when answer is fine" do
      let(:name) { "Paul" }
      let(:assigner_resolver) { Assigner.new(:name) }

      it "properly assigns data to user" do
        expect{message.process_answer(name)}.to change{user.name}.to(name)
      end

      it "adds message to user messages" do
        message.process_answer(name)
        expect(user.last_message).to eq(name)
      end

      it "returns next message in flow" do
        next_message = double
        message.next_message_resolver = Caller.new(next_message)
        expect(message.process_answer(name).next_message).to eq(next_message)
      end
    end

  end
end
