Given(/^que não estou conectado ao site$/) do
  visit '/pt-BR/users/sign_out'
end

When(/^me inscrevo com dados válidos$/) do
  create_visitor
  sign_up
end

When(/^me inscrevo sem um nome$/) do
  create_visitor
  @visitor[:name] = " "
  sign_up
end

When(/^me inscrevo com um e\-mail inválido$/) do
  create_visitor
  @visitor[:email] = "invalidemail"
  sign_up
end

When(/^me inscrevo sem uma senha$/) do
  create_visitor
  @visitor[:password] = " "
  sign_up
end

When(/^me inscrevo com a confirmação da senha diferente da senha$/) do
  create_visitor
  @visitor[:password_confirmation] = " "
  sign_up
end

Then(/^devo ver uma mensagem de conta criada com sucesso$/) do
  expect(page).to have_content "Bem-vindo! Sua conta foi criada com sucesso."
end

Then(/^devo ver uma mensagem de nome ausente$/) do
  expect(page).to have_content "Nome completo não pode ficar em branco"
end

Then(/^devo ver uma mensagem de e\-mail inválido$/) do
  expect(page).to have_content "Endereço de e-mail não é válido"
end

Then(/^devo ver uma mensagem de senha ausente$/) do
  expect(page).to have_content "Senha não pode ficar em branco"
end

Then(/^devo ver uma mensagem de confirmação incorreta$/) do
  expect(page).to have_content "Confirmação de senha não é igual a Senha"
end