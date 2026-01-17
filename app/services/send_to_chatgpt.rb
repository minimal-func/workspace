require 'net/http'
require 'json'

class SendToChatgpt
  def initialize(message)
    @message = message
  end

  def call
    uri = URI.parse("https://api.openai.com/v1/chat/completions")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Authorization"] = "Bearer #{ENV['OPENAI_API_KEY']}"
    request.body = {
      model: 'gpt-3.5-turbo-16k',
      messages: [{ role: 'user', content: @message }]
    }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    response_body = JSON.parse(response.body)
    response_body.dig('choices', 0, 'message', 'content')
  end
end