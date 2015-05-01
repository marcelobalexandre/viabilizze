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
    @project = current_user.projects.create(project_params)
    respond_with(current_user, @project)
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    @project.update(project_params)
    respond_with(current_user, @project)
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    respond_with(@project, location: user_projects_path(current_user))
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end
end