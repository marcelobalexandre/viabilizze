class UnitsController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_user, only: [:index, :show, :new, :edit]

  def index
    @units = current_project.units.by_name(params[:search]).paginate(page: params[:page])
  end

  def show
    @unit = Unit.find(params[:id])
  end

  def new
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
    @unit = current_project.units.create(unit_params)
    respond_with(@unit, location: user_project_path(current_user, current_project))
  end

  def edit
    @unit = Unit.find(params[:id])
  end

  def update
    @unit = Unit.find(params[:id])
    @unit.update(unit_params)
    respond_with(current_user, current_project, @unit)
  end

  def destroy
    @unit = Unit.find(params[:id])
    @unit.destroy
    respond_with(@unit, location: user_project_path(current_user, current_project))
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