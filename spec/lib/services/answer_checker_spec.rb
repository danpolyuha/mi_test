require "services/answer_checker"

RSpec.describe AnswerChecker do

  let(:checker) { described_class.new(user: user, answer_pattern: answer_pattern) }

  let(:user) { double(contact_method: "phone") }

  context "when answer_pattern is regex" do
    let(:answer_pattern) { /yes|no/ }

    describe "#acceptable_answer?" do
      it "returns true when answer matches" do
        expect(checker.acceptable_answer?("yes")).to be_truthy
      end

      it "returns false when answer doesn't match" do
        expect(checker.acceptable_answer?("maybe")).to be_falsey
      end
    end

    describe "#pattern" do
      it "returns answer_pattern itself" do
        expect(checker.pattern).to eq(answer_pattern)
      end
    end
  end

  context "when answer_pattern is complex" do
    let(:phone_pattern) { /\d+/ }
    let(:answer_pattern) { ->(user) { user.contact_method == "phone" ? phone_pattern : /\w+/ } }

    describe "acceptable_answer?" do
      it "returns true when answer matches" do
        expect(checker.acceptable_answer?("12345")).to be_truthy
      end

      it "returns false when answer doesn't match" do
        expect(checker.acceptable_answer?("yes")).to be_falsey
      end
    end

    describe "#pattern" do
      it "correctly finds needed pattern" do
        expect(checker.pattern).to eq(phone_pattern)
      end
    end
  end

end
