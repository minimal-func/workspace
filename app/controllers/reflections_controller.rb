class ReflectionsController < ApplicationController
  def index
    @reflections = current_user.reflections.order(created_at: :desc).with_rich_text_content
  end
end
