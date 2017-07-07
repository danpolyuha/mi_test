require "message"

RSpec.describe Message do

  let(:message) { build(:message,
                        text_template: text_template,
                        answer_pattern_template: answer_pattern_template,
                        assigner: assigner,
                        user: user) }

  let(:text_template) { "blablabla" }
  let(:answer_pattern_template) { nil }
  let(:assigner) { nil }
  let(:user) { build(:user) }

  describe "#get_text" do
    it "returns generated text" do
      expect(message.get_text).to eq(text_template)
    end
  end

  describe "#process_answer" do

    context "when answer doesn't meet pattern" do
      let(:answer_pattern_template) { /[A-Za-z]+/ }
      let(:result) { message.process_answer("1234") }

      it "returns failure" do
        expect(result.success?).to be_falsey
      end

      it "returns error message" do
        expect(result.error_message).to include(answer_pattern_template.inspect)
      end
    end

    context "when answer is fine" do
      let(:name) { "Paul" }
      let(:next_message) { build(:message) }
      let(:assigner) { :name }

      before do
        message.add_to_flow(/#{name}/ => next_message)
      end

      it "properly assigns data to user" do
        expect{message.process_answer(name)}.to change{user.name}.to(name)
      end

      it "returns next message in flow" do
        expect(message.process_answer(name).next_message).to eq(next_message)
      end
    end

  end
end
