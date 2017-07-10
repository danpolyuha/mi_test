require "core/wrappers/assigner"

RSpec.describe Assigner do

  let(:assigner) { described_class.new(attribute) }

  describe "#call" do
    let(:name) { "Paul" }
    let(:user) { create(:user) }

    context "when attribute is symbol" do
      let(:attribute) { :name }

      it "assigns value to given attribute" do
        expect{assigner.call(user, name)}.to change{user.name}.to(name)
      end
    end

    context "when attribute is proc" do
      let(:attribute) { ->(user) { user.name = name } }

      it "calls assigning proc passign corresponding object" do
        expect{assigner.call(user)}.to change{user.name}.to(name)
      end
    end

  end
end
