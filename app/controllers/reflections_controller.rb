class ReflectionsController < ApplicationController
  def index
    @pagy, @reflections = pagy(current_user.reflections.order(created_at: :desc).with_rich_text_content, items: 10)
  end
end
