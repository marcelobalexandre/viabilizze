class MultipleUnitsController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_user, only: [:new]

  def new
    @project = Project.find(params[:project_id])
    @multiple_units = MultipleUnits.new
  end

  def create
    @project = Project.find(params[:project_id])
    @multiple_units = MultipleUnits.new(multiple_units_params)
    @multiple_units.exchanged = params[:exchanged] == '1'
    @multiple_units.project_id = @project.id

    if @multiple_units.valid?
      multiple_units_creator = MultipleUnitsCreator.new
      multiple_units_creator.create_multiple_units(@project, @multiple_units) 
      flash[:success] = t('.flash_success')
      redirect_to user_project_path(current_user, @project)
    else
      render 'new'
    end
  end

  private

  def multiple_units_params
    params.require(:multiple_units).permit(:quantity,
                                           :name, 
                                           :private_area,
                                           :common_area,
                                           :box_area,
                                           :exchanged,
                                           :project_id)
  end
end