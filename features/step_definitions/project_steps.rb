When(/^crio um empreendimento com dados válidos$/) do
  new_project
  register_new_project
end

When(/^crio um empreendimento sem nome$/) do
  new_project
  @new_project[:name] = " "
  register_new_project
end

Then(/^devo ver uma mensagem de empreendimento criado com sucesso$/) do
  expect(page).to have_content "Empreendimento criado com sucesso."
end

Then(/^devo visualizar o empreendimento$/) do
  expect(page).to have_content @new_project[:name]
end

Then(/^devo ver uma mensagem de nome do empreedimento ausente$/) do
  expect(page).to have_content "Nome não pode ficar em branco"
end