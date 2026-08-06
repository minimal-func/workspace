class InvitationsController < ApplicationController
  layout "onboard"

  before_action :authenticate_user!

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = current_user.sent_invitations.new(invitation_params)

    if @invitation.save
      redirect_to invitation_path(@invitation), notice: "Invitation created successfully. Share the sign-up link with the invited user."
    else
      render :new
    end
  end

  def show
    @invitation = current_user.sent_invitations.find(params[:id])
  end

  private

  def invitation_params
    params.require(:invitation).permit(:email)
  end
end
