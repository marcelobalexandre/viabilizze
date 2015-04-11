class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_user, only: [:index, :show, :new]

  def index
    @projects = current_user.projects.paginate(page: params[:page])    
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

  def validate_user
    if params[:user_id]
      @user = User.where(id: params[:user_id]).first
      if @user != current_user
        flash[:alert] = t('.restricted_access')
        redirect_to root_url
      end      
    end
  end

  def project_params
    params.require(:project).permit(:name)
  end
end