module Notifications
  class ImagesController < ApplicationController
    before_action :authenticate_user!
    
    def create
      file = params[:image]
      
      blob = ActiveStorage::Blob.create_and_upload!(
        io: file,
        filename: file.original_filename,
        content_type: file.content_type
      )

      render json: {
        success: 1,
        file: {
          url: rails_blob_url(blob, only_path: true)
        }
      }
    end

    def fetch_url
      url = params[:url]
      render json: {
        success: 1,
        file: {
          url: url
        }
      }
    end
  end
end
