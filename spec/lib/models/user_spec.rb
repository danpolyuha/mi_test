require "models/user"

RSpec.describe User do

  let(:user) { create(:user) }
  let(:text) { "new line" }

  describe "#add_line" do
    it "creates new line and adds it to user" do
      user.add_line(text)
      expect(user.lines.last.text).to eq(text)
    end
  end

  describe "#last_line_text" do
    it "returns last created line" do
      user.add_line("12345")
      user.add_line(text)
      expect(user.last_line_text).to eq(text)
    end

    it "returns nil if there's no lines" do
      expect(user.last_line_text).to be_nil
    end
  end

end
