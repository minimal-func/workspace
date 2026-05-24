require 'rails_helper'

RSpec.describe LlmRouter do
  def with_clean_env
    orig_openai = ENV.delete('OPENAI_API_KEY')
    orig_anthropic = ENV.delete('ANTHROPIC_API_KEY')
    orig_openrouter = ENV.delete('OPENROUTER_API_KEY')
    yield
  ensure
    ENV['OPENAI_API_KEY'] = orig_openai if orig_openai
    ENV['ANTHROPIC_API_KEY'] = orig_anthropic if orig_anthropic
    ENV['OPENROUTER_API_KEY'] = orig_openrouter if orig_openrouter
  end

  describe '#initialize' do
    it 'defaults to OpenAI when OPENAI_API_KEY is set' do
      with_clean_env do
        ENV['OPENAI_API_KEY'] = 'sk-test'
        stub_request(:post, 'https://api.openai.com/v1/chat/completions')
          .to_return(status: 200, body: { choices: [{ message: { content: 'ok' } }] }.to_json, headers: { 'Content-Type' => 'application/json' })
        expect(LlmRouter.new.chat([{ role: 'user', content: 'hi' }])).to eq('ok')
      end
    end

    it 'defaults to Anthropic when ANTHROPIC_API_KEY is set' do
      with_clean_env do
        ENV['ANTHROPIC_API_KEY'] = 'sk-ant-test'
        stub_request(:post, 'https://api.anthropic.com/v1/messages')
          .to_return(status: 200, body: { content: [{ text: 'ok' }] }.to_json, headers: { 'Content-Type' => 'application/json' })
        expect(LlmRouter.new.chat([{ role: 'user', content: 'hi' }])).to eq('ok')
      end
    end

    it 'defaults to OpenRouter when OPENROUTER_API_KEY is set' do
      with_clean_env do
        ENV['OPENROUTER_API_KEY'] = 'sk-or-test'
        stub_request(:post, 'https://openrouter.ai/api/v1/chat/completions')
          .to_return(status: 200, body: { choices: [{ message: { content: 'ok' } }] }.to_json, headers: { 'Content-Type' => 'application/json' })
        expect(LlmRouter.new.chat([{ role: 'user', content: 'hi' }])).to eq('ok')
      end
    end

    it 'prefers OpenRouter over other providers when multiple keys are set' do
      with_clean_env do
        ENV['OPENROUTER_API_KEY'] = 'sk-or-test'
        ENV['OPENAI_API_KEY'] = 'sk-test'
        stub_request(:post, 'https://openrouter.ai/api/v1/chat/completions')
          .to_return(status: 200, body: { choices: [{ message: { content: 'via openrouter' } }] }.to_json, headers: { 'Content-Type' => 'application/json' })
        expect(LlmRouter.new.chat([{ role: 'user', content: 'hi' }])).to eq('via openrouter')
      end
    end

    it 'raises when no provider is configured' do
      with_clean_env do
        expect { LlmRouter.new }.to raise_error(RuntimeError, /No LLM provider configured/)
      end
    end

    it 'raises for unsupported provider' do
      with_clean_env do
        ENV['OPENAI_API_KEY'] = 'sk-test'
        expect { LlmRouter.new(provider: :ollama) }.to raise_error(ArgumentError, /Unsupported provider/)
      end
    end

    it 'accepts a custom model override' do
      with_clean_env do
        ENV['OPENAI_API_KEY'] = 'sk-test'
        router = LlmRouter.new(model: 'gpt-4')
        expect(router.instance_variable_get(:@model)).to eq('gpt-4')
      end
    end
  end

  describe '#chat' do
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

    let(:router) { LlmRouter.new }

    context 'with OpenAI provider' do
      it 'calls the OpenAI API and returns the response content' do
        stub_request(:post, 'https://api.openai.com/v1/chat/completions')
          .with(
            body: hash_including(
              model: 'gpt-4o-mini',
              messages: [{ role: 'user', content: 'Hello' }],
              temperature: 0.7
            )
          )
          .to_return(
            status: 200,
            body: { choices: [{ message: { content: 'Hi there!' } }] }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        result = router.chat([{ role: 'user', content: 'Hello' }])
        expect(result).to eq('Hi there!')
      end

      it 'includes system prompt when provided' do
        stub_request(:post, 'https://api.openai.com/v1/chat/completions')
          .with(body: hash_including(
            messages: [
              { role: 'system', content: 'You are a bot.' },
              { role: 'user', content: 'Hi' }
            ]
          ))
          .to_return(
            status: 200,
            body: { choices: [{ message: { content: 'Hello' } }] }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        result = router.chat([{ role: 'user', content: 'Hi' }], system: 'You are a bot.')
        expect(result).to eq('Hello')
      end

      it 'includes max_tokens when provided' do
        stub_request(:post, 'https://api.openai.com/v1/chat/completions')
          .with(body: hash_including(max_tokens: 50))
          .to_return(
            status: 200,
            body: { choices: [{ message: { content: 'Short' } }] }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        result = router.chat([{ role: 'user', content: 'Hi' }], max_tokens: 50)
        expect(result).to eq('Short')
      end
    end

    context 'with OpenRouter provider' do
      around do |example|
        orig_openai = ENV['OPENAI_API_KEY']
        orig_openrouter = ENV['OPENROUTER_API_KEY']
        ENV.delete('OPENAI_API_KEY')
        ENV['OPENROUTER_API_KEY'] = 'sk-or-test'
        example.run
        ENV['OPENAI_API_KEY'] = orig_openai
        ENV['OPENROUTER_API_KEY'] = orig_openrouter
      end

      it 'calls the OpenRouter API (OpenAI-compatible) and returns the response content' do
        stub_request(:post, 'https://openrouter.ai/api/v1/chat/completions')
          .with(
            body: hash_including(
              model: 'openai/gpt-4o-mini',
              messages: [{ role: 'user', content: 'Hello' }],
              temperature: 0.7
            )
          )
          .to_return(
            status: 200,
            body: { choices: [{ message: { content: 'Hi from OpenRouter!' } }] }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        router = LlmRouter.new(provider: :openrouter)
        result = router.chat([{ role: 'user', content: 'Hello' }])
        expect(result).to eq('Hi from OpenRouter!')
      end

      it 'includes system prompt and max_tokens' do
        stub_request(:post, 'https://openrouter.ai/api/v1/chat/completions')
          .with(body: hash_including(
            messages: [
              { role: 'system', content: 'You are a bot.' },
              { role: 'user', content: 'Hi' }
            ],
            max_tokens: 100
          ))
          .to_return(
            status: 200,
            body: { choices: [{ message: { content: 'Hello' } }] }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        router = LlmRouter.new(provider: :openrouter)
        result = router.chat([{ role: 'user', content: 'Hi' }], system: 'You are a bot.', max_tokens: 100)
        expect(result).to eq('Hello')
      end
    end

    context 'with Anthropic provider' do
      around do |example|
        orig_openai = ENV['OPENAI_API_KEY']
        orig_anthropic = ENV['ANTHROPIC_API_KEY']
        orig_openrouter = ENV['OPENROUTER_API_KEY']
        ENV.delete('OPENAI_API_KEY')
        ENV.delete('OPENROUTER_API_KEY')
        ENV['ANTHROPIC_API_KEY'] = 'sk-ant-test'
        example.run
        ENV['OPENAI_API_KEY'] = orig_openai
        ENV['ANTHROPIC_API_KEY'] = orig_anthropic
        ENV['OPENROUTER_API_KEY'] = orig_openrouter
      end

      it 'calls the Anthropic API and returns the response content' do
        stub_request(:post, 'https://api.anthropic.com/v1/messages')
          .with(
            body: hash_including(
              model: 'claude-3-haiku-20240307',
              messages: [{ role: 'user', content: 'Hello' }],
              temperature: 0.7
            )
          )
          .to_return(
            status: 200,
            body: { content: [{ text: 'Hi from Claude!' }] }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        router = LlmRouter.new
        result = router.chat([{ role: 'user', content: 'Hello' }])
        expect(result).to eq('Hi from Claude!')
      end

      it 'includes system prompt separately' do
        stub_request(:post, 'https://api.anthropic.com/v1/messages')
          .with(body: hash_including(system: 'You are Claude.'))
          .to_return(
            status: 200,
            body: { content: [{ text: 'OK' }] }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        router = LlmRouter.new
        result = router.chat([{ role: 'user', content: 'Hi' }], system: 'You are Claude.')
        expect(result).to eq('OK')
      end
    end
  end
end
