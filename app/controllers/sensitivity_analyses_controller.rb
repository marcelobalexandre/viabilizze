class SensitivityAnalysesController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_user, only: [:index, :show, :new, :edit]

  def index
    @sensitivity_analyses = current_project.sensitivity_analyses.paginate(page: params[:page])
  end

  def show
    @sensitivity_analysis = SensitivityAnalysis.find(params[:id])
    UnitSensitivityAnalysesInitializer.call(@sensitivity_analysis)
  end

  def new
    @sensitivity_analysis = current_project.sensitivity_analyses.build
    UnitSensitivityAnalysesInitializer.call(@sensitivity_analysis)
  end

  def create
    @sensitivity_analysis = current_project.sensitivity_analyses.create(sensitivity_analysis_params)
    respond_with(current_user, current_project, @sensitivity_analysis)
  end

  def edit
    @sensitivity_analysis = SensitivityAnalysis.find(params[:id])
    UnitSensitivityAnalysesInitializer.call(@sensitivity_analysis)
  end

  def update
    @sensitivity_analysis = SensitivityAnalysis.find(params[:id])
    @sensitivity_analysis.update(sensitivity_analysis_params)
    respond_with(current_user, current_project, @sensitivity_analysis)
  end

  def destroy
    @sensitivity_analysis = SensitivityAnalysis.find(params[:id])
    @sensitivity_analysis.destroy
    respond_with(@sensitivity_analysis, location: user_project_sensitivity_analyses_path(current_user, current_project))
  end

  private

  def sensitivity_analysis_params
    params.require(:sensitivity_analysis).permit(:name,
                                                 :net_profit_margin,
                                                 :sales_commissions_rate,
                                                 :sales_taxes_rate,
                                                 :sales_charges_rate,
                                                 :individualization_costs,
                                                 :cost_per_square_meter,
                                                 :land_acquisition_cost,
                                                 :exchanged_units_expenses,
                                                 unit_sensitivity_analyses_attributes: [:id, :sale_price, :unit_id])
  end
end