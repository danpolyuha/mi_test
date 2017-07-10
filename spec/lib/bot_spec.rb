require "bot"
require "scenarios/test"

RSpec.describe Bot do
  let(:bot) { Bot.new("test") }

  describe "#talk" do

    before do
      expect(bot).to receive(:gets).and_return "Ringo"
    end

    it "puts first message" do
      expect{bot.talk}.to output("hello\n").to_stdout
    end

    it "reads the reply and processes it" do
      bot.talk
      expect(User.last.name).to eq("Ringo")
    end

  end

end