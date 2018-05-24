class EnergyLevelsController < ApplicationController
  def index
    @energy_levels = current_user.energy_levels.order(created_at: :desc)
  end
end
