# require "message_flow_builder"
#
# RSpec.describe MessageFlowBuilder do
#
#   let(:builder) do
#     described_class.new do
#
#       message key: :message1,
#               text: first_message_text
#
#       message key: :message2,
#               text: "Input your phone",
#               answer_pattern: /\+?\d+/,
#               assigner: :phone
#
#       flow message1: :message2
#
#     end
#   end
#
#   let(:first_message_text) { "Welcome!" }
#
#   describe "#first_message" do
#     it "correctly returns first message" do
#       expect(builder.first_message.get_text).to eq(first_message_text)
#     end
#   end
#
# end
