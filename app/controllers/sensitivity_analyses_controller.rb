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

  def report
    @sensitivity_analysis = SensitivityAnalysis.find(params[:id])
  end

  def selling_price
    @sensitivity_analysis = params[:id] ? SensitivityAnalysis.find(params[:id]) : current_project.sensitivity_analyses.build
    @sensitivity_analysis.net_profit_margin = params[:net_profit_margin].to_d
    @sensitivity_analysis.sales_commissions_rate = params[:sales_commissions_rate].to_d
    @sensitivity_analysis.sales_taxes_rate = params[:sales_taxes_rate].to_d
    @sensitivity_analysis.sales_charges_rate = params[:sales_charges_rate].to_d
    @sensitivity_analysis.individualization_costs = params[:individualization_costs].to_d
    @sensitivity_analysis.cost_per_square_meter = params[:cost_per_square_meter].to_d
    @sensitivity_analysis.land_acquisition_cost = params[:land_acquisition_cost].to_d
    @sensitivity_analysis.exchanged_units_expenses = params[:exchanged_units_expenses].to_d
    UnitSensitivityAnalysesInitializer.call(@sensitivity_analysis)

    unit_sensitivity_analysis = @sensitivity_analysis.unit_sensitivity_analyses.select { |u| u.unit_id == params[:unit_id].to_i }.first

    data = { selling_price: unit_sensitivity_analysis.selling_price }
    render json: data, status: :ok
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