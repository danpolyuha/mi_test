require "core/wrappers/caller"

RSpec.describe Caller do

  let(:caller) { described_class.new(callee) }
  let(:result) { "result" }

  describe "#call" do

    context "when callee is proc" do
      let(:callee) { ->(param) { result + param } }

      it "returns result of callee execution" do
        expect(caller.call("123")).to eq("result123")
      end
    end

    context "when callee is not proc" do
      let(:callee) { result }

      it "returns callee itself" do
        expect(caller.call).to eq(result)
      end
    end

  end
end
