require "services/answer_checker"

RSpec.describe AnswerChecker do

  let(:checker) { described_class.new(user: build(:user, name: name),
                                      answer_pattern_template: answer_pattern_template) }
  let(:name) { "Paul" }

  describe "#acceptable_answer?" do

    context "when answer_pattern_template is regex" do
      let(:answer_pattern_template) { /yes|no/ }

      it "returns true when answer matches" do
        expect(checker.acceptable_answer?("yes")).to be_truthy
      end

      it "returns false when answer doesn't match" do
        expect(checker.acceptable_answer?("maybe")).to be_falsey
      end
    end

    context "when answer_pattern is complex" do
      let(:answer_pattern_template) { ->(user) { user.name == name ? /\d+/ : /\w+/ } }

      it "returns true when answer matches" do
        expect(checker.acceptable_answer?("12345")).to be_truthy
      end

      it "returns false when answer doesn't match" do
        expect(checker.acceptable_answer?("yes")).to be_falsey
      end
    end
  end

  describe "#answer_pattern" do

    context "when answer_pattern_template is regex" do
      let(:answer_pattern_template) { /yes|no/ }

      it "returns answer_pattern_template itself" do
        expect(checker.answer_pattern).to eq(answer_pattern_template)
      end
    end

    context "when answer_pattern_template is complex" do
      let(:phone_pattern) { /\d+/ }
      let(:answer_pattern_template) { ->(user) { user.name == name ? phone_pattern : /\w+/ } }

      describe "#answer_pattern" do
        it "correctly finds needed pattern" do
          expect(checker.answer_pattern).to eq(phone_pattern)
        end
      end
    end

    context "when answer_pattern_template type is not supported" do
      let(:answer_pattern_template) { 55 }

      describe "#answer_pattern" do
        it "raises exception" do
          expect{checker.answer_pattern}.to raise_error(RuntimeError)
        end
      end
    end

  end
end
