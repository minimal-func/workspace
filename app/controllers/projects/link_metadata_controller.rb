module Projects
  class LinkMetadataController < ApplicationController
    before_action :authenticate_user!

    def fetch
      url = params[:url]
      return render json: { success: 0 } if url.blank?

      begin
        page = MetaInspector.new(url, faraday_options: { ssl: { verify: false } })
        
        render json: {
          success: 1,
          meta: {
            title: page.title,
            description: page.description,
            image: {
              url: page.images.best
            }
          }
        }
      rescue => e
        logger.error "LinkTool metadata fetch failed: #{e.message}"
        render json: { success: 0 }
      end
    end
  end
end
