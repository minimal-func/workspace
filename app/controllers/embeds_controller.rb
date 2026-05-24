class EmbedsController < ApplicationController

  def create
    @embed = Embed.create(params.require(:embed).permit(:content))

    respond_to do |format|
      if @embed.persisted?
        format.json
      else
        format.json { render json: { error: @embed.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

end
