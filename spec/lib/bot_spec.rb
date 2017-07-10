require "bot"

module Scenarios
  def self.test
    ->{
      message :m1,
              text: "hello",
              assigner: :name
    }
  end
end

RSpec.describe Bot do
  let(:bot) do
    bot = Bot.new("test")
    expect(bot).to receive(:gets).and_return "Ringo"
    bot
  end

  describe "#talk" do

    it "puts first message" do
      expect{bot.talk}.to output("hello\n").to_stdout
    end

    it "reads the reply and processes it" do
      bot.talk
      expect(User.last.name).to eq("Ringo")
    end

  end

end
