class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_user, only: [:index, :show, :new, :edit]

  def index
    @projects = current_user.projects.by_name(params[:search]).paginate(page: params[:page])
  end

  def show
    @project = Project.find(params[:id])
    @units = @project.units.by_name(params[:search]).paginate(page: params[:page])  
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_user.projects.build(project_params)

    if @project.save
      flash[:success] = t('.flash_success')
      redirect_to user_project_path(current_user, @project)
    else
      render 'new'
    end
  end

  def edit
    @project = Project.find(params[:id])    
  end

  def update
    @project = Project.find(params[:id])

    if @project.update(project_params)
      flash[:success] = t('.flash_success')
      redirect_to user_project_path(current_user, @project)
    else
      render 'edit'
    end
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end
end