class SendToChatgpt
  def initialize(message)
    @message = message
  end

  def call
    LlmRouter.new.chat([{ role: "user", content: @message }])
  rescue => e
    Rails.logger.error("ChatGPT API error: #{e.message}")
    "Sorry, I couldn't process that request. Please try again in a moment."
  end
end