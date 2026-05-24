require 'rails_helper'

RSpec.describe SendToChatgpt, type: :service do
  describe "#call" do
    let(:message) { "Hello, how are you?" }
    let(:service) { described_class.new(message) }

    it "delegates to LlmRouter" do
      router_instance = instance_double(LlmRouter)
      expect(LlmRouter).to receive(:new).and_return(router_instance)
      expect(router_instance).to receive(:chat)
        .with([{ role: "user", content: message }])
        .and_return("I'm doing well!")

      result = service.call
      expect(result).to eq("I'm doing well!")
    end
  end
end
