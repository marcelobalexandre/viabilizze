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
