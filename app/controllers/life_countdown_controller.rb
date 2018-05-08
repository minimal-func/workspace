class LifeCountdownController < ApplicationController
  def new
    @life_countdown = current_user.life_countdown || LifeCountdown.new
  end

  def create
    life_countdown = current_user.life_countdown

    return redirect_to dashboards_url if life_countdown && life_countdown.update_attributes(life_countdown_params)
    return redirect_to dashboards_url if !life_countdown && current_user.create_life_countdown(life_countdown_params)

    render :new
  end

  private

  def life_countdown_params
    params.require(:life_countdown).permit(:id,
      :born_in, :planned_years
    )
  end
end
