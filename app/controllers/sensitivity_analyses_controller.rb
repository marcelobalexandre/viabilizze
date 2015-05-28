class SensitivityAnalysesController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_user, only: [:index, :show, :new, :edit]
  before_action :validate_sensitivity_analysis, only: [:report, :charts]

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

  def charts
    @sensitivity_analysis = SensitivityAnalysis.find(params[:id])
    data = get_data_to_charts(@sensitivity_analysis)

    respond_to do |format|
      format.html
      format.json { render json: data, status: :ok }
    end
  end

  def selling_price
    @sensitivity_analysis = params[:id] ? SensitivityAnalysis.find(params[:id]) : current_project.sensitivity_analyses.build
    @sensitivity_analysis.assign_attributes(selling_price_params)
    UnitSensitivityAnalysesInitializer.call(@sensitivity_analysis)

    unit_sensitivity_analysis = @sensitivity_analysis.unit_sensitivity_analyses.select { |u| u.unit_id == params[:unit_id].to_i }.first

    data = { selling_price: unit_sensitivity_analysis.selling_price }
    render json: data, status: :ok
  end

  private

  def get_data_to_charts(sensitivity_analysis)
    { construction_costs: sensitivity_analysis.construction_costs.to_s.to_d,
      individualization_costs: sensitivity_analysis.individualization_costs.to_s.to_d,
      land_acquisition_cost: sensitivity_analysis.land_acquisition_cost.to_s.to_d,
      sales_commissions: sensitivity_analysis.sales_commissions.to_s.to_d,
      sales_taxes: sensitivity_analysis.sales_taxes.to_s.to_d,
      sales_charges: sensitivity_analysis.sales_charges.to_s.to_d,
      exchanged_units_expenses: sensitivity_analysis.exchanged_units_expenses.to_s.to_d }
  end

  def validate_sensitivity_analysis
    if params[:id]
      sensitivity_analysis = SensitivityAnalysis.find(params[:id])
      if !sensitivity_analysis.completed
          flash[:message] = t('.incomplete_sensitivity_analysis')
          redirect_to user_project_sensitivity_analyses_path(current_user, current_project)
      end
    end
  end

  def selling_price_params
    params.require(:selling_price).permit(:net_profit_margin,
                                          :sales_commissions_rate,
                                          :sales_taxes_rate,
                                          :sales_charges_rate,
                                          :individualization_costs,
                                          :cost_per_square_meter,
                                          :land_acquisition_cost,
                                          :exchanged_units_expenses)
  end

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