require "utilities/regexp_hash"

RSpec.describe RegexpHash do

  let(:flow) do
    flow = RegexpHash.new
    flow.merge!(
        /^\d+$/ => "number",
        /^[A-Za-z]+$/ => "text",
        /@/ => "email",
        1 => 2
    )
  end

  describe "#match" do
    it "returns nil if argument is not string" do
      expect(flow.match(1)).to be_nil
    end

    it "finds first value with key matching provided string" do
      expect(flow.match("123")).to eq("number")
      expect(flow.match("blabla")).to eq("text")
      expect(flow.match("john123@email.com")).to eq("email")
    end

    it "returns nil if nothing was matched" do
      expect(flow.match("asd123")).to be_nil
    end
  end
end
