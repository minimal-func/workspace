class MoodsController < ApplicationController
  def index
    @pagy, @moods = pagy(current_user.moods.order(created_at: :desc), items: 30)
  end
end
