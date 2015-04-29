module SensitivityAnalysisHelper
  def new_sensitivity_analysis
    @new_sensitivity_analysis = FactoryGirl.attributes_for(:sensitivity_analysis)
  end

  def register_new_sensitivity_analysis(project)
    visit "/pt-BR/users/#{project.user.id}/projects/#{project.id}/sensitivity_analyses/new"

    fill_in "sensitivity_analysis_name",         with: @new_sensitivity_analysis[:name]

    click_button "Salvar"

    @sensitivity_analysis = SensitivityAnalysis.where(name: @new_sensitivity_analysis[:name]).first
  end
end

World(SensitivityAnalysisHelper) if respond_to?(:World)