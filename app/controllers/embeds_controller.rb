class EmbedsController < ApplicationController

  def create
    @embed = Embed.create!(params.require(:embed).permit(:content))

    respond_to do |format|
      format.json
    end
  end

end
