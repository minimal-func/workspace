module Projects
  class MaterialsController < ApplicationController
    before_action :authenticate_user!, only: %i[new create index edit update new_folder create_folder]
    before_action :set_project, only: %i[new create index new_folder create_folder]
    before_action :set_material, only: %i[show edit update]
    before_action :set_current_folder, only: %i[index new create new_folder create_folder]

    def new
      @material = @project.materials.build
      @material.parent = @current_folder
    end

    def create
      @material = @project.materials.build(material_params)
      @material.parent = @current_folder
      @material.is_folder = false
      
      if @material.save
        # Award points for creating a material
        GamificationService.award_points_for(:create_material, current_user, @material) if current_user
        redirect_to project_materials_path(@project, folder_id: @current_folder&.id)
      else
        render :new
      end
    end

    def new_folder
      @folder = @project.materials.build
      @folder.parent = @current_folder
      @folder.is_folder = true
    end

    def create_folder
      @folder = @project.materials.build(folder_params)
      @folder.parent = @current_folder
      @folder.is_folder = true
      
      if @folder.save
        redirect_to project_materials_path(@project, folder_id: @current_folder&.id)
      else
        render :new_folder
      end
    end

    def index
      if @current_folder
        @materials = @current_folder.children.order(:is_folder => :desc, :title => :asc)
        @breadcrumbs = @current_folder.ancestors + [@current_folder]
      else
        @materials = @project.materials.root_items.order(:is_folder => :desc, :title => :asc)
        @breadcrumbs = []
      end
    end

    def show
      @project = @material.project
    end

    def edit
      @project = @material.project
    end

    def update
      @project = @material.project
      if @material.update(material_params)
        redirect_to project_materials_path(@project), notice: 'Material was successfully updated.'
      else
        render :edit
      end
    end

    private

    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_material
      @material = Material.find(params[:id])
    end

    def set_current_folder
      @current_folder = params[:folder_id] ? @project.materials.find(params[:folder_id]) : nil
    end

    def material_params
      params.require(:material).permit(:title, :short_description, :file)
    end

    def folder_params
      params.require(:material).permit(:title, :short_description)
    end
  end
end
