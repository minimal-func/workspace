class EnergyLevelsController < ApplicationController
  def index
    @pagy, @energy_levels = pagy(current_user.energy_levels.order(created_at: :desc), items: 30)
  end
end
