class UnitsController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_user, only: [:index, :show, :new, :edit]

  def index
    @project = Project.find(params[:project_id])
    @units = @project.units.by_name(params[:search]).paginate(page: params[:page])
  end

  def show
    @project = Project.find(params[:project_id])
    @unit = Unit.find(params[:id])
  end

  def new
    @project = Project.find(params[:project_id])
    @unit = Unit.new

    if params[:unit_id]
      unit_to_copy = Unit.find(params[:unit_id])
      @unit.name = unit_to_copy.name
      @unit.private_area = unit_to_copy.private_area
      @unit.common_area = unit_to_copy.common_area
      @unit.box_area = unit_to_copy.box_area
      @unit.exchanged = unit_to_copy.exchanged
    end 
  end

  def create
    @project = Project.find(params[:project_id])
    @unit = @project.units.build(unit_params)

    if @unit.save
      flash[:success] = t('.flash_success')
      redirect_to user_project_path(current_user, @project)
    else
      render 'new'
    end
  end

  def edit
    @project = Project.find(params[:project_id])
    @unit = Unit.find(params[:id])    
  end

  def update
    @project = Project.find(params[:project_id])
    @unit = Unit.find(params[:id])

    if @unit.update(unit_params)
      flash[:success] = t('.flash_success')
      redirect_to user_project_unit_path(current_user, @project, @unit)
    else
      render 'edit'
    end
  end

  private

  def unit_params
    params.require(:unit).permit(:name, 
                                 :private_area,
                                 :common_area,
                                 :box_area,
                                 :exchanged)
  end
end