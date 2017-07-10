require "scenarios/matic"
require "processor"

RSpec.describe "Matic scenario" do

  let(:start_stage) { Processor.new(Scenarios.matic) }

  describe "conversation" do

    it "starts conversation" do
      expect(start_stage.current_text).to eq("I can help you with answers to all your related questions and help to find a great job!")
    end

    it "makes sure first reply is correct" do
      expect(start_stage.reply("really?")).to eq('Provided reply can not be accepted. Please follow reply format: /\blet\'s talk\b/i')
    end

    let(:name_stage) { start_stage.tap{|processor| processor.reply("LET's taLK")} }

    it "asks for name" do
      expect(name_stage.current_text).to eq("Please enter your name:")
    end

    let(:contact_method_stage) { name_stage.tap{|processor| processor.reply("John Lennon") } }

    it "asks for contact method" do
      expect(contact_method_stage.current_text).to eq("Hello John Lennon, how can we reach out to you?")
    end

    it "makes sure contact method is correct" do
      expect(contact_method_stage.reply("what about mind reading?")).to eq('Provided reply can not be accepted. Please follow reply format: /\bphone|email|i don\'t want to be contacted\b/i')
    end

    describe "tragic end" do
      let(:failure_stage) { contact_method_stage.tap{|processor| processor.reply("i DON'T want TO be CONTACTED") } }

      it "tells how sad it is" do
        expect(failure_stage.current_text).to eq("Sad to hear that. Whenever you change your mind - feel free to send me a message.")
      end
    end

    describe "happy end: email" do
      let(:email_stage) { contact_method_stage.tap{|processor| processor.reply("email") } }

      it "asks for email" do
        expect(email_stage.current_text).to eq("Please type your email address:")
      end

      it "makes sure email is correct" do
        expect(email_stage.reply("12345")).to eq('Provided reply can not be accepted. Please follow reply format: /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b/i')
      end

      let(:confirmation_stage) {
        email_stage.tap{|processor| processor.reply("me@email.com")}
      }

      it "confirms email" do
        expect(confirmation_stage.current_text).to eq("We are going to contact you using email: me@email.com")
      end

      it "makes sure answer to confirmation is correct" do
        expect(confirmation_stage.reply("no, please don't!")).to eq('Provided reply can not be accepted. Please follow reply format: /\byes, please|sorry, wrong email\b/i')
      end

      let(:email_stage_again) { confirmation_stage.tap{|processor| processor.reply("sorry, wrong EMAIL")} }

      it "goes back to email if it has to be updated" do
        expect(email_stage_again.current_text).to eq("Please type your email address:")
      end

      it "finishes conversation if everything's fine" do
        expect(confirmation_stage.reply("yes, PLEAse")).to be_nil
      end
    end

    describe "happy end: phone" do
      let(:phone_stage) { contact_method_stage.tap{|processor| processor.reply("phone") } }

      it "asks for phone" do
        expect(phone_stage.current_text).to eq("Please type your phone number:")
      end

      it "makes sure phone is correct" do
        expect(phone_stage.reply("blabla")).to eq('Provided reply can not be accepted. Please follow reply format: /\b\+?\d+\b/')
      end

      let(:contact_time_stage) { phone_stage.tap{|processor| processor.reply("+380987654321")} }

      it "asks for contact time" do
        expect(contact_time_stage.current_text).to eq("What is the best time we can reach out to you?")
      end

      it "makes sure contact time is correct" do
        expect(contact_time_stage.reply("now!")).to eq('Provided reply can not be accepted. Please follow reply format: /\basap|morning|afternoon|evening\b/i')
      end

      let(:confirmation_stage) { contact_time_stage.tap{|processor| processor.reply("morning") } }

      it "confirms phone" do
        expect(confirmation_stage.current_text).to eq("We are going to contact you using phone: +380987654321")
      end

      it "makes sure answer to confirmation is correct" do
        expect(confirmation_stage.reply("no, please don't!")).to eq('Provided reply can not be accepted. Please follow reply format: /\byes, please|sorry, wrong phone\b/i')
      end

      let(:phone_stage_again) { confirmation_stage.tap{|processor| processor.reply("sorry, WRONG phone")} }

      it "goes back to phone if it has to be updated" do
        expect(phone_stage_again.current_text).to eq("Please type your phone number:")
      end

      it "finishes conversation if everything's fine" do
        expect(confirmation_stage.reply("yes, PLEAse")).to be_nil
      end
    end

  end
end
