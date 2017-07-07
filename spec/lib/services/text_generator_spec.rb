require "services/text_generator"

RSpec.describe TextGenerator do

  let(:generator) { described_class.new(text_template: text_template, user: build(:user, name: name)) }
  let(:name) { "John" }

  describe "#generate" do

    context "when template is plain text" do
      let(:text_template) { "Strawberry fields forever" }

      it "returns template itself" do
        expect(generator.generate).to eq(text_template)
      end
    end

    context "when interpolation has to be used" do
      let(:text_template) { ->(user) { "Paul, #{user.name}, and George" } }

      it "returns template itself" do
        expect(generator.generate).to eq("Paul, John, and George")
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
