class ReflectionsController < ApplicationController
  def index
    @reflections = current_user.reflections
  end
end
