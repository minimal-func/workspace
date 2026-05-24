class ChatgptController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def index
  end

  def create
    message = params[:message]

    chatgpt_message = SendToChatgpt.new(message).call
    render json: { message: chatgpt_message }
  rescue => e
    render json: { error: "Failed to get response. Please try again." }, status: :service_unavailable
  end
end