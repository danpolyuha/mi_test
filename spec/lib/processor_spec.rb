require "processor"

RSpec.describe Processor do

  let(:bot) { described_class.new(scenario) }
  let(:scenario) { ->{
    message :message1,
            text: "Hello!",
            next_message: :message2

    message :message2,
            text: "Good bye!"
  }}

  describe "#current_text" do
    it "returns text of current message" do
      expect(bot.current_text).to eq("Hello!")
    end
  end

  describe "#reply" do
    it "processes reply and returns new message" do
      expect(bot.reply("hi")).to eq("Good bye!")
    end
  end

end
