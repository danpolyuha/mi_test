require "services/data_assigner"

RSpec.describe DataAssigner do

  let(:data_assigner) { described_class.new(assigner: assigner, user: user) }

  let(:user) { build(:user) }
  let(:data) { "John" }

  describe "#assign" do

    context "when assigner is single attribute" do
      let(:assigner) { :name }

      it "assigns data to the attribute" do
        expect(user).to receive("#{assigner}=").with(data)
        data_assigner.assign data
      end
    end

    context "when assigner is complex" do
      let(:assigner) { ->(data, user) { user.name = data } }

      it "calls the assigner" do
        expect(user).to receive("name=").with(data)
        data_assigner.assign data
      end
    end

    context "when assigner type is not supported" do
      let(:assigner) { 34 }

      it "raises exception" do
        expect{data_assigner.assign data}.to raise_error(RuntimeError)
      end
    end

  end

end
