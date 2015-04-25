Given(/^que tenho empreendimentos com unidades cadastrados$/) do
    @projects = FactoryGirl.create_list(:project, 3, user_id: @user.id)
    @projects.each do |project| 
      units = FactoryGirl.create_list(:unit, 3, project_id: project.id)  
      units.each { |unit| project.units << unit }

      @user.projects << project
    end
end

When(/^crio uma unidade com dados válidos$/) do
  new_unit
  register_new_unit(@projects.first)
end

When(/^crio uma unidade sem nome$/) do
  new_unit
  @new_unit[:name] = " "
  register_new_unit(@projects.first)
end

When(/^tento criar uma unidade para empreendimento de outro usuário$/) do
  visit "/pt-BR/users/#{@another_user.id}/projects/#{@project_from_another_user.id}/units/new"
end

Then(/^devo ver uma mensagem de unidade adicionada com sucesso$/) do
  expect(page).to have_content "Unidade adicionada com sucesso."
end

Then(/^devo visualizar o empreendimento com a nova unidade$/) do
  expect(page).to have_content @projects.first.name
  expect(page).to have_content @new_unit[:name]
end

Then(/^devo ver uma mensagem de nome da unidade ausente$/) do
  expect(page).to have_content "Nome não pode ficar em branco"
end

When(/^acesso um empreendimento próprio$/) do
  visit "/pt-BR/users/#{@user.id}/projects/#{@projects.first.id}"
end

When(/^clico em Adicionar Unidade$/) do
  click_link "Adicionar Unidade"
end

When(/^clico em Copiar Unidade$/) do
  first('#copy-unit-button').click
end

When(/^clico em uma unidade existente$/) do
  first('.unit-information').click
end

When(/^crio múltiplas unidades com dados válidos$/) do
  new_multiple_units
  register_new_multiple_units(@projects.first)
end

When(/^crio múltiplas unidades sem nome$/) do
  new_multiple_units
  @new_multiple_units[:name] = " "
  register_new_multiple_units(@projects.first)
end

When(/^tento criar múltiplas unidades para empreendimento de outro usuário$/) do
  visit "/pt-BR/users/#{@another_user.id}/projects/#{@project_from_another_user.id}/multiple_units/new"
end

Then(/^devo ver os dados da unidade selecionada nos campos da unidade sendo cadastrada$/) do
  expect(page).to have_content @projects.first.units.first.name
end

Then(/^devo ver uma mensagem de múltiplas unidades adicionadas com sucesso$/) do
  expect(page).to have_content "Múltiplas unidades adicionadas com sucesso."
end

Then(/^devo visualizar o empreendimento com as novas unidades$/) do
  expect(page).to have_content @projects.first.name
  expect(@multiple_units.count).to be > 0
  @multiple_units.each { |unit| expect(page).to have_content unit[:name] }  
end

Then(/^devo ver uma mensagem de nome para múltiplas unidades ausente$/) do
  expect(page).to have_content "Nome não pode ficar em branco"
end