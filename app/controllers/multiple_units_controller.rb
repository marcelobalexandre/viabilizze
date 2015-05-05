class MultipleUnitsController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_user, only: [:new]

  def new
    @multiple_units = MultipleUnits.new
  end

  def create
    @multiple_units = MultipleUnits.new(multiple_units_params)
    @multiple_units.exchanged = params[:exchanged] == '1'
    @multiple_units.project_id = current_project.id

    if @multiple_units.valid?
      MultipleUnitsCreator.call(current_project, @multiple_units)
      flash[:success] = t('.flash_success')
      redirect_to user_project_path(current_user, current_project)
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