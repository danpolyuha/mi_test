require "core/services/lines_saver"

RSpec.describe LinesSaver do

  let(:saver) { described_class.new(user) }
  let(:user) { create(:user) }

  describe "#user_line" do

    context "when text is nil" do
      it "does nothing" do
        expect{saver.user_line(nil)}.not_to change{Line.count}
      end
    end

    context "when text is not nil" do
      it "saves user message" do
        expect{saver.user_line("Hello!")}.to change{user.reload.last_line_text}.from(nil).to("USER: Hello!")
      end
    end

  end

  describe "#bot_line" do

    context "when text is nil" do
      it "does nothing" do
        expect{saver.bot_line(nil)}.not_to change{Line.count}
      end
    end

    context "when text is not nil" do
      it "saves bot message" do
        expect{saver.bot_line("Hello!")}.to change{user.reload.last_line_text}.from(nil).to("BOT: Hello!")
      end
    end

  end

end
