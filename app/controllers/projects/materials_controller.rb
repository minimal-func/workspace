module Projects
  class MaterialsController < ApplicationController
    before_action :authenticate_user!, only: %i[new create index edit update]
    before_action :set_project, only: %i[new create index]
    before_action :set_material, only: %i[show edit update]

    def new
      @material = @project.materials.build
    end

    def create
      @material = @project.materials.build(material_params)
      @material.save!
      redirect_to project_materials_path(@project)
    end

    def index
      @materials = @project.materials
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

    def material_params
      params.require(:material).permit(:title, :short_description, :file)
    end
  end
end
