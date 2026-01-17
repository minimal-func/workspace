module Projects
  class TodosController < ApplicationController
    before_action :authenticate_user!
    before_action :set_project, only: %i[new create index]
    before_action :set_todo, only: %i[update show edit destroy]

    def new
      @todo = @project.todos.build
    end

    def edit
      @project = @todo.project
    end

    def create
      @todo = @project.todos.build(todo_params)
      @todo.save!
      
      # Award points for creating a todo
      GamificationService.award_points_for(:create_todo, current_user, @todo) if current_user
      
      redirect_to project_todos_path(@project)
    end

    def index
      @todos = @project.todos
    end

    def show
      @project = @todo.project
    end

    def update
      @project = @todo.project
      was_finished = @todo.finished?
      @todo.update(todo_params)

      # Award points for completing a todo (only when marking as finished)
      if !was_finished && @todo.finished? && current_user
        GamificationService.award_points_for(:complete_todo, current_user, @todo)
      end

      respond_to do |format|
        format.html { redirect_to project_todos_path(@project) }
        format.turbo_stream
      end
    end

    def destroy
      @project = @todo.project
      @todo.destroy
      redirect_to project_todos_path(@project)
    end

    private

    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_todo
      @todo = Todo.find(params[:id])
    end

    def todo_params
      params.require(:todo).permit(:name, :finished)
    end
  end
end
