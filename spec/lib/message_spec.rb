require "message"

RSpec.describe Message do

  let(:message) { described_class.new(text_template: text_template,
                                      answer_pattern_template: answer_pattern_template,
                                      assigner: assigner,
                                      user: user) }
  let(:text_template) { "Hello!" }
  let(:answer_pattern_template) { /yes|no/ }
  let(:user) { double("name=": nil) }
  let(:assigner) { :name }

  describe "#get_text" do
    let(:text_generator) { double(generate: text_template) }

    it "returns generated text" do
      expect(message).to receive(:text_generator).and_return(text_generator)
      expect(message.get_text).to eq(text_template)
    end
  end

  describe "#process_answer" do

    describe "checking the answer" do
      let(:answer_checker) { double(acceptable_answer?: false, answer_pattern: answer_pattern_template) }
      let(:result) { message.process_answer("maybe") }

      it "returns failure is checking fails" do
        expect(message).to receive(:answer_checker).at_least(:once).and_return(answer_checker)
        expect(result.success?).to be_falsey
      end

      it "returns error message" do
        expect(message).to receive(:answer_checker).at_least(:once).and_return(answer_checker)
        expect(result.error_message).to include(answer_pattern_template.inspect)
      end
    end

    context "assigning data" do
      let(:data_assigner) { double(assign: nil) }

      it "assigns input data" do
        data = "John"
        allow(message).to receive(:acceptable_answer?).and_return(true)
        expect(message).to receive(:data_assigner).and_return(data_assigner)
        expect(data_assigner).to receive(:assign).with(data)
        message.process_answer(data)
      end
    end

  end

end
