Given(/^que não estou conectado ao site$/) do
  visit '/pt-BR/users/sign_out'
end

Given(/^que não estou cadastrado$/) do
  create_visitor
  delete_user
end

Given(/^que estou cadastrado$/) do
  create_user
end

Given(/^que me conectei com lembrar\-me marcado$/) do
  create_user
  sign_in_with_remember_me_checked
end

Given(/^que me conectei com lembrar\-me desmarcado$/) do
  create_user
  sign_in_with_remember_me_unchecked
end

Given(/^que solicitei o reset da minha senha com o e\-mail$/) do
  create_user
  visit '/pt-BR/users/sign_out'
  request_password_reset_with_email
  click_button "Redefinir Senha"
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

When(/^me conectar com e\-mail e senha válidos$/) do
  create_visitor
  sign_in
end

When(/^me conectar com um e\-mail incorreto$/) do
  @visitor = @visitor.merge(:email => "wrong@example.com")
  sign_in
end

When(/^fechar meu navegador$/) do
  expire_cookies
end

When(/^abrir meu navegador novamente$/) do
  visit '/pt-BR'
end

When(/^me conectar com uma senha incorreta$/) do
  @visitor = @visitor.merge(:password => "wrongpassword")
  sign_in
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

Then(/^devo ver uma mensagem de conexão inválida$/) do
  expect(page).to have_content "E-mail ou senha inválidos."
end

Then(/^devo estar desconectado$/) do
  expect(page).to have_button "Entrar"
  expect(page).to have_content "Não tem uma conta? Criar Conta"
  expect(page).to_not have_content "Sair"
end

Then(/^devo ver uma mensagem de conexão realizada com sucesso$/) do
  expect(page).to have_content "Conectado com sucesso."
end

Then(/^devo estar conectado$/) do
  expect(page).to have_xpath("//a[@href='/pt-BR/users/sign_out']")
  expect(page).to_not have_content "Entrar"
  expect(page).to_not have_content "Não tem uma conta? Criar Conta"
end

Then(/^devo receber um e\-mail com as instruções do reset\.$/) do
  unread_emails_for(@user.email).should be_present
end
