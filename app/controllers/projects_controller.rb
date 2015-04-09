class ProjectsController < ApplicationController
  def index
  end

  def show
    @project = Project.find(params[:id])    
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_user.projects.build(project_params)

    if @project.save
      flash[:success] = t('.flash_success')
      redirect_to user_project_path(@project, current_user)
    else
      render 'new'
    end
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end
end