require "message"

RSpec.describe Message do

  let(:message) { Message.new(text_pattern: text_pattern, answer_pattern: answer_pattern) }
  let(:text_pattern) { "Hello!" }

  describe "#process_answer" do

    context "when answer doesn't match the answer pattern" do
      let(:answer_pattern) { /yes|no/ }
      let(:result) { message.process_answer("maybe") }

      it "fails" do
        expect(result.success?).to be_falsey
      end

      it "returns error message" do
        expect(result.error_message).to include(answer_pattern.inspect)
      end
    end
  end

end
