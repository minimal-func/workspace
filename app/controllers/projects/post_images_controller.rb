module Projects
  class PostImagesController < ApplicationController
    before_action :authenticate_user!
    
    def create
      # Check if user has permission to upload to this project
      @project = Project.find(params[:project_id])
      unless current_user.can_update_resource?(@project)
        render json: { success: 0 }, status: :forbidden
        return
      end

      # For Editor.js Image plugin, it sends the file in 'image' param
      file = params[:image]
      
      # We can attach it to a temporary object or use ActiveStorage directly
      # Since Editor.js needs a URL, we'll use ActiveStorage and return the blob URL
      
      # For now, let's use a simpler approach: attach it to the project or post if it exists
      # But Editor.js image upload happens before the post is necessarily saved
      # Let's attach it to the project as a generic attachment for now
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
      # In a real app, you'd download the image and re-host it or just return the URL
      # For now, let's just return the same URL if it's valid
      render json: {
        success: 1,
        file: {
          url: url
        }
      }
    end
  end
end
