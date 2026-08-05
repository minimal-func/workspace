module Notifications
  class ImagesController < ApplicationController
    before_action :authenticate_user!
    
    def create
      file = params[:image]
      
      allowed_types = %w[image/jpeg image/png image/gif image/webp image/svg+xml]
      unless file && allowed_types.include?(file.content_type)
        render json: { success: 0, error: "Invalid file type. Allowed: JPEG, PNG, GIF, WebP, SVG" }, status: :unprocessable_entity
        return
      end

      if file.size > 10.megabytes
        render json: { success: 0, error: "File must be smaller than 10MB" }, status: :unprocessable_entity
        return
      end

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
