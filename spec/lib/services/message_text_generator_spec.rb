require 'services/message_text_generator'

RSpec.describe MessageTextGenerator do

  let(:generator) { described_class.new(text_template: text_template, user: user) }

  let(:user_name) { "John" }
  let(:user) { double(name: user_name) }

  describe "#generate" do

    context "when template is plain text" do
      let(:text_template) { "Strawberry fields forever" }

      it "returns template itself" do
        expect(generator.generate).to eq(text_template)
      end
    end

    context "when interpolation has to be used" do
      let(:text_template) { ->(user) { "Paul, #{user.name}, and Goerge" } }

      it "returns template itself" do
        expect(generator.generate).to eq("Paul, John, and Goerge")
      end
    end

    context "when template type is not supported" do
      let(:text_template) { 14 }

      it "raises exception" do
        expect{generator.generate}.to raise_error(RuntimeError)
      end
    end
  end

end
