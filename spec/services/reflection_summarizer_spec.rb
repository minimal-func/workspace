require 'rails_helper'

RSpec.describe ReflectionSummarizer, type: :service do
  describe '#summarize' do
    around do |example|
      orig_openai = ENV['OPENAI_API_KEY']
      orig_anthropic = ENV['ANTHROPIC_API_KEY']
      orig_openrouter = ENV['OPENROUTER_API_KEY']
      ENV['OPENAI_API_KEY'] = 'sk-test'
      ENV.delete('ANTHROPIC_API_KEY')
      ENV.delete('OPENROUTER_API_KEY')
      example.run
      ENV['OPENAI_API_KEY'] = orig_openai
      ENV['ANTHROPIC_API_KEY'] = orig_anthropic if orig_anthropic
      ENV['OPENROUTER_API_KEY'] = orig_openrouter if orig_openrouter
    end

    let(:user) { FactoryBot.create(:user) }

    it 'returns nil when given no reflections' do
      summarizer = ReflectionSummarizer.new([])
      expect(summarizer.summarize).to be_nil
    end

    it 'sends reflections to the LLM and returns a summary' do
      reflection = FactoryBot.create(:reflection, user: user, created_at: Time.zone.local(2026, 5, 1))
      allow(reflection.content).to receive(:to_plain_text).and_return('Had a great day at work.')

      stub_request(:post, 'https://api.openai.com/v1/chat/completions')
        .with(body: /Had a great day at work/)
        .to_return(
          status: 200,
          body: { choices: [{ message: { content: 'You had a productive day.' } }] }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      summarizer = ReflectionSummarizer.new([reflection])
      expect(summarizer.summarize).to eq('You had a productive day.')
    end

    it 'extracts text from body_json when present' do
      reflection = FactoryBot.create(:reflection, user: user)
      reflection.update_column(:body_json, {
        time: 1_234_567,
        blocks: [
          { type: 'paragraph', data: { text: 'First paragraph.' } },
          { type: 'paragraph', data: { text: 'Second paragraph.' } }
        ],
        version: '2.28.2'
      }.to_json)

      stub_request(:post, 'https://api.openai.com/v1/chat/completions')
        .with(body: /First paragraph.*Second paragraph/)
        .to_return(
          status: 200,
          body: { choices: [{ message: { content: 'Summary text.' } }] }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      summarizer = ReflectionSummarizer.new([reflection])
      expect(summarizer.summarize).to eq('Summary text.')
    end

    it 'handles multiple reflections' do
      r1 = FactoryBot.create(:reflection, user: user, created_at: Time.zone.local(2026, 5, 1))
      r2 = FactoryBot.create(:reflection, user: user, created_at: Time.zone.local(2026, 5, 2))
      allow(r1.content).to receive(:to_plain_text).and_return('Felt tired.')
      allow(r2.content).to receive(:to_plain_text).and_return('More energy today.')

      stub_request(:post, 'https://api.openai.com/v1/chat/completions')
        .with(body: /Felt tired.*More energy today/)
        .to_return(
          status: 200,
          body: { choices: [{ message: { content: 'Your energy improved.' } }] }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      summarizer = ReflectionSummarizer.new([r1, r2])
      expect(summarizer.summarize).to eq('Your energy improved.')
    end
  end
end
