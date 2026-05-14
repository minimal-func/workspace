require 'rails_helper'

RSpec.describe SendToChatgpt, type: :service do
  describe "#call" do
    let(:message) { "Hello, how are you?" }
    let(:service) { described_class.new(message) }

    it "sends a request to OpenAI API" do
      stub_request(:post, "https://api.openai.com/v1/chat/completions")
        .with(
          body: hash_including(
            model: 'gpt-3.5-turbo-16k',
            messages: [{ role: 'user', content: message }]
          )
        )
        .to_return(
          status: 200,
          body: { choices: [{ message: { content: "I'm doing well!" } }] }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      result = service.call
      expect(result).to eq("I'm doing well!")
    end
  end
end
