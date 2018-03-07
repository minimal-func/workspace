class ReflectionsController < ApplicationController
  def index
    @reflections = current_user.reflections.order(created_at: :desc)
  end
end
