module Projects
  class TodosController < ApplicationController
    before_action :authenticate_user!, only: %i[new create index]
    before_action :set_project, only: %i[new create index]

    def new
      @todo = @project.todos.build
    end

    def create
      @todo = @project.todos.build(todo_params)
      @todo.save!
      redirect_to project_todos_path(@project)
    end

    def index
      @todos = @project.todos
    end

    def show
      @todo = Todo.find(params[:id])
      @project = @todo.project
    end

    private

    def set_project
      @project = Project.find(params[:project_id])
    end

    def todo_params
      params.require(:todo).permit(:name, :finished)
    end
  end
end