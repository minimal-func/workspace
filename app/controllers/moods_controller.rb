class MoodsController < ApplicationController
  def index
    @moods = current_user.moods.order(created_at: :desc)
  end
end