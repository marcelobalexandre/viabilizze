Given(/^que tenho empreendimentos com análises de sensibilidade cadastrados$/) do
  @projects = FactoryGirl.create_list(:project, 3, user_id: @user.id)
  @projects.each do |project|
    sensitivity_analyses = FactoryGirl.create_list(:sensitivity_analysis, 3, project_id: project.id)
    sensitivity_analyses.each { |sensitivity_analysis| project.sensitivity_analyses << sensitivity_analysis }

    @user.projects << project
  end
end

Given(/^que existem empreendimentos com análises de sensibilidade de outros usuários cadastrados$/) do
  @another_user = FactoryGirl.create(:user)
  @project_from_another_user = FactoryGirl.create(:project, user_id: @another_user.id)
  sensitivity_analyses = FactoryGirl.create_list(:sensitivity_analysis, 3, project_id: @project_from_another_user.id)
  sensitivity_analyses.each { |sensitivity_analysis| @project_from_another_user.sensitivity_analyses << sensitivity_analysis }
  @another_user.projects << @project_from_another_user
end

When(/^crio uma análise de sensibilidade com dados válidos$/) do
  new_sensitivity_analysis
  register_new_sensitivity_analysis(@projects.first)
end

When(/^crio uma análise de sensibilidade sem nome$/) do
  new_sensitivity_analysis
  @new_sensitivity_analysis[:name] = " "
  register_new_sensitivity_analysis(@projects.first)
end

When(/^tento criar uma análise de sensibilidade para empreendimento de outro usuário$/) do
  visit "/pt-BR/users/#{@another_user.id}/projects/#{@project_from_another_user.id}/sensitivity_analyses/new"
end

When(/^abrir uma análise de sensibilidade própria$/) do
  visit "/pt-BR/users/#{@user.id}/projects/#{@projects.first.id}/sensitivity_analyses/#{@projects.first.sensitivity_analyses.first.id}"
end

When(/^abrir uma análise de sensibilidade de outro usuário$/) do
  visit "/pt-BR/users/#{@another_user.id}/projects/#{@project_from_another_user.id}/sensitivity_analyses/#{@project_from_another_user.sensitivity_analyses.first.id}"
end

When(/^altero dados de uma análise de sensibilidade própria$/) do
  visit "/pt-BR/users/#{@user.id}/projects/#{@projects.first.id}/sensitivity_analyses/#{@projects.first.sensitivity_analyses.first.id}/edit"
  fill_in "sensitivity_analysis_name", with: "New Sensitivity Analysis Name"
  click_button "Salvar"
end

When(/^abro uma análise de sensibilidade de outro usuário para edição$/) do
  visit "/pt-BR/users/#{@another_user.id}/projects/#{@project_from_another_user.id}/sensitivity_analyses/#{@project_from_another_user.sensitivity_analyses.first.id}/edit"
end

When(/^excluo uma análise de sensibilidade própria$/) do
  visit "/pt-BR/users/#{@user.id}/projects/#{@projects.first.id}/sensitivity_analyses/#{@projects.first.sensitivity_analyses.first.id}"
  expect do
    click_link('Excluir', match: :first)
  end.to change(SensitivityAnalysis.all, :count).by(-1)
end

Then(/^devo ver uma mensagem de análise de sensibilidade adicionada com sucesso$/) do
  expect(page).to have_content "Análise de Sensibilidade adicionada com sucesso."
end

Then(/^devo visualizar a análise de sensibilidade$/) do
  expect(page).to have_content @new_sensitivity_analysis[:name]
end

Then(/^devo ver uma mensagem de nome da análise de sensibilidade ausente$/) do
  expect(page).to have_content "Nome não pode ficar em branco"
end

Then(/^devo visualizar minha análise de sensibilidade$/) do
  expect(page).to have_content @projects.first.sensitivity_analyses.first.name
end

Then(/^devo ver uma mensagem de análise de sensibilidade atualizada com sucesso$/) do
  expect(page).to have_content "Análise de Sensibilidade atualizada com sucesso."
end

Then(/^devo visualizar a análise de sensibilidade atualizada$/) do
  expect(page).to have_content "New Sensitivity Analysis Name"
end

Then(/^devo ver uma mensagem de análise de sensibilidade excluída com sucesso$/) do
  expect(page).to have_content "Análise de Sensibilidade excluída com sucesso."
end
