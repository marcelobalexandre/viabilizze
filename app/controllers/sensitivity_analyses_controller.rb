class SensitivityAnalysesController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_user, only: [:index, :show, :new, :edit]

  def index
    @project = Project.find(params[:project_id])
    @sensitivity_analyses = @project.sensitivity_analyses.paginate(page: params[:page])
  end

  def show
    @project = Project.find(params[:project_id])
    @sensitivity_analysis = SensitivityAnalysis.find(params[:id])
  end

  def new
    @project = Project.find(params[:project_id])
    @sensitivity_analysis = SensitivityAnalysis.new
  end

  def create
    @project = Project.find(params[:project_id])
    @sensitivity_analysis = @project.sensitivity_analyses.build(sensitivity_analysis_params)

    if @sensitivity_analysis.save
      flash[:success] = t('.flash_success')
      redirect_to user_project_sensitivity_analysis_path(current_user, @project, @sensitivity_analysis)
    else
      render 'new'
    end
  end

  def edit
    @project = Project.find(params[:project_id])
    @sensitivity_analysis = SensitivityAnalysis.find(params[:id])
  end

  def update
    @project = Project.find(params[:project_id])
    @sensitivity_analysis = SensitivityAnalysis.find(params[:id])

    if @sensitivity_analysis.update(sensitivity_analysis_params)
      flash[:success] = t('.flash_success')
      redirect_to user_project_sensitivity_analysis_path(current_user, @project, @sensitivity_analysis)
    else
      render 'edit'
    end
  end

  def destroy
    @project = Project.find(params[:project_id])
    @sensitivity_analysis = SensitivityAnalysis.find(params[:id])
    @sensitivity_analysis.destroy
    flash[:success] = t('.flash_success')
    redirect_to user_project_sensitivity_analyses_path(current_user, @project)
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
                                                 :exchanged_units_expenses)
  end
end