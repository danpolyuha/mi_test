require "core/services/reply_checker"
require "core/wrappers/caller"

RSpec.describe ReplyChecker do

  let(:checker) { described_class.new(Caller.new(/\d+/), build(:user)) }

  describe "#acceptable_reply?" do
    it "returns true if reply matches pattern" do
      expect(checker.acceptable_reply?("123")).to be_truthy
    end

    it "returns false if reply doesn't match pattern" do
      expect(checker.acceptable_reply?("abc")).to be_falsey
    end
  end

  describe "#reply_format_failure" do
    it "forms arror message" do
      expect(checker.reply_format_failure.error_message).to eq('Provided reply can not be accepted. Please follow reply format: /\d+/')
    end
  end

end
