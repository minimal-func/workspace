module Projects
  class MaterialsController < ApplicationController
    before_action :authenticate_user!, only: %i[new create index]
    before_action :set_project, only: %i[new create index]

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
      @material = Material.find(params[:id])
      @workspace = @material.project
    end

    private

    def set_project
      @project = Project.find(params[:project_id])
    end

    def material_params
      params.require(:material).permit(:title, :short_description, :file)
    end
  end
end