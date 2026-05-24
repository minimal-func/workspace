require 'net/http'
require 'json'

class LlmRouter
  module Provider
    OPENAI = :openai
    ANTHROPIC = :anthropic
    OPENROUTER = :openrouter
  end

  DEFAULT_MODELS = {
    Provider::OPENAI => 'gpt-4o-mini',
    Provider::ANTHROPIC => 'claude-3-haiku-20240307',
    Provider::OPENROUTER => 'openai/gpt-4o-mini'
  }.freeze

  SUPPORTED_PROVIDERS = [Provider::OPENAI, Provider::ANTHROPIC, Provider::OPENROUTER].freeze

  def initialize(provider: nil, model: nil)
    @provider = (provider || detect_provider).to_sym
    @model = model || DEFAULT_MODELS[@provider]
    raise ArgumentError, "Unsupported provider: #{@provider}" unless SUPPORTED_PROVIDERS.include?(@provider)
    validate_credentials!
  end

  def chat(messages, system: nil, temperature: 0.7, max_tokens: nil)
    case @provider
    when Provider::OPENAI then openai_compatible_chat("https://api.openai.com/v1/chat/completions", ENV['OPENAI_API_KEY'], messages, system, temperature, max_tokens)
    when Provider::ANTHROPIC then anthropic_chat(messages, system, temperature, max_tokens)
    when Provider::OPENROUTER then openai_compatible_chat("https://openrouter.ai/api/v1/chat/completions", ENV['OPENROUTER_API_KEY'], messages, system, temperature, max_tokens)
    end
  end

  private

  def detect_provider
    if ENV['OPENROUTER_API_KEY']
      Provider::OPENROUTER
    elsif ENV['ANTHROPIC_API_KEY']
      Provider::ANTHROPIC
    elsif ENV['OPENAI_API_KEY']
      Provider::OPENAI
    else
      raise "No LLM provider configured. Set OPENROUTER_API_KEY, OPENAI_API_KEY, or ANTHROPIC_API_KEY."
    end
  end

  def validate_credentials!
    case @provider
    when Provider::OPENAI
      raise "OPENAI_API_KEY is not set" unless ENV['OPENAI_API_KEY']
    when Provider::ANTHROPIC
      raise "ANTHROPIC_API_KEY is not set" unless ENV['ANTHROPIC_API_KEY']
    when Provider::OPENROUTER
      raise "OPENROUTER_API_KEY is not set" unless ENV['OPENROUTER_API_KEY']
    end
  end

  def openai_compatible_chat(base_url, api_key, messages, system, temperature, max_tokens)
    uri = URI(base_url)
    req = Net::HTTP::Post.new(uri)
    req.content_type = "application/json"
    req["Authorization"] = "Bearer #{api_key}"

    body = { model: @model, messages: messages, temperature: temperature }
    body[:messages] = [{ role: "system", content: system }] + messages if system
    body[:max_tokens] = max_tokens if max_tokens
    req.body = body.to_json

    http = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true)
    res = http.request(req)
    JSON.parse(res.body).dig("choices", 0, "message", "content")
  end

  def anthropic_chat(messages, system, temperature, max_tokens)
    uri = URI("https://api.anthropic.com/v1/messages")
    req = Net::HTTP::Post.new(uri)
    req.content_type = "application/json"
    req["x-api-key"] = ENV['ANTHROPIC_API_KEY']
    req["anthropic-version"] = "2023-06-01"

    body = {
      model: @model,
      messages: messages,
      temperature: temperature,
      max_tokens: max_tokens || 1024
    }
    body[:system] = system if system
    req.body = body.to_json

    http = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true)
    res = http.request(req)
    JSON.parse(res.body).dig("content", 0, "text")
  end
end
