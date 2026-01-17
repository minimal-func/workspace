class ChatgptController < ApplicationController
  protect_from_forgery with: :null_session, only: :create

  def index

  end

  def create
    message = params[:message]

    chatgpt_message = SendToChatgpt.new(message).call

    render json: { message: chatgpt_message }
  end
end