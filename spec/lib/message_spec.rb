require "message"

RSpec.describe Message do

  let(:message) { described_class.new(text_template: text_template, answer_pattern: answer_pattern, user: user) }
  let(:text_template) { "Hello!" }
  let(:answer_pattern) { /yes|no/ }
  let(:user) { double }

  describe "#get_text" do
    let(:text_generator) { double(generate: text_template) }

    it "returns generated text" do
      expect(message).to receive(:text_generator).and_return(text_generator)
      expect(message.get_text).to eq(text_template)
    end
  end

  describe "#process_answer" do

    describe "checking the answer" do
      let(:answer_checker) { double(acceptable_answer?: false, pattern: answer_pattern) }
      let(:result) { message.process_answer("maybe") }

      it "returns failure is checking fails" do
        expect(result.success?).to be_falsey
      end

      it "returns error message" do
        expect(result.error_message).to include(answer_pattern.inspect)
      end
    end

  end

end
