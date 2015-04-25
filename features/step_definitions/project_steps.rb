Given(/^que existem empreendimentos de outros usuários cadastrados$/) do
  @another_user = FactoryGirl.create(:user)
  @project_from_another_user = FactoryGirl.create(:project, user_id: @another_user.id)
  @another_user.projects << @project_from_another_user
end

Given(/^que não tenho empreendimentos cadastrados$/) do
end

Given(/^que tenho empreendimentos cadastrados$/) do
  @projects = FactoryGirl.create_list(:project, 3, user_id: @user.id)
  @projects.each { |project| @user.projects << project }
end

When(/^crio um empreendimento com dados válidos$/) do
  new_project
  register_new_project(@user)
end

When(/^crio um empreendimento sem nome$/) do
  new_project
  @new_project[:name] = " "
  register_new_project(@user)
end

When(/^abrir minha lista de empreendimentos$/) do
  visit "/pt-BR/users/#{@user.id}/projects"
end

When(/^abrir a lista de empreendimentos de outro usuário$/) do
  visit "/pt-BR/users/#{@another_user.id}/projects"
end

When(/^tento criar um empreendimento para outro usuário$/) do
  visit "/pt-BR/users/#{@another_user.id}/projects/new"
end

When(/^abrir um empreendimento próprio$/) do
  visit "/pt-BR/users/#{@user.id}/projects/#{@projects.first.id}"
end

When(/^abrir um empreendimento de outro usuário$/) do
  visit "/pt-BR/users/#{@another_user.id}/projects/#{@project_from_another_user.id}"
end

When(/^pesquisar pelo nome de um empreendimento cadastrado$/) do
  @searched_project = @projects.first
  fill_in "search", with: @searched_project.name
  click_button "search-button"
end

When(/^pesquisar pelo nome de um empreendimento não cadastrado$/) do
  fill_in "search", with: "Unknown Project"
  click_button "search-button"
end

When(/^pesquisar com o campo em branco$/) do
  fill_in "search", with: " "
  click_button "search-button"
end

When(/^altero dados de um empreendimento próprio$/) do
  visit "/pt-BR/users/#{@user.id}/projects/#{@projects.first.id}/edit"
  fill_in "project_name", with: "New Project Name"
  click_button "Salvar"
end

When(/^abro um empreendimento de outro usuário para edição$/) do
  visit "/pt-BR/users/#{@another_user.id}/projects/#{@project_from_another_user.id}/edit"
end

When(/^excluo um empreendimento próprio$/) do
  visit "/pt-BR/users/#{@user.id}/projects/#{@projects.first.id}"
  expect do
    click_link('Excluir', match: :first)
  end.to change(Project.all, :count).by(-1)
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

Then(/^devo visualizar uma informação de que não existem empreendimentos cadastrados$/) do
  expect(page).to have_content "Nenhum empreendimento"
end

Then(/^devo visualizar um botão para adicionar novos empreendimentos$/) do
  expect(page).to have_link("Adicionar Empreendimento", href: new_user_project_path('pt-BR', @user))
end

Then(/^não devo visualizar empreendimentos de outros usuários$/) do
  expect(page).not_to have_content @project_from_another_user.name
end

Then(/^devo visualizar meus empreendimentos$/) do
  @projects.each { |project| expect(page).to have_content project.name }
end

Then(/^não devo visualizar uma informação de que não existem empreendimentos cadastrados$/) do
  expect(page).not_to have_content "Nenhum empreendimento"
end

Then(/^não devo visualizar um botão para adicionar novos empreendimentos$/) do
  expect(page).not_to have_link("Adicionar Empreendimento", href: new_user_project_path('pt-BR', @user))
end

Then(/^devo ver uma mensagem de acesso restrito$/) do
  expect(page).to have_content "Você tentou acessar uma página não permitida e foi redirecionado."
end

Then(/^devo visualizar meu empreendimento$/) do
  expect(page).to have_content @projects.first.name
end

Then(/^devo ver uma mensagem de que é necessário se conectar$/) do
  expect(page).to have_content "Você precisa se conectar ou registrar antes de prosseguir."
end

Then(/^devo visualizar o empreendimento pesquisado$/) do
  expect(page).to have_content @searched_project.name
end

Then(/^não devo visualizar os empreendimentos não pesquisados$/) do
  @projects.each do |project|
    unless project == @searched_project
      expect(page).not_to have_content project.name
    end
  end
end

Then(/^não devo visualizar meus empreendimentos$/) do
  @projects.each { |project| expect(page).not_to have_content project.name }
end

Then(/^devo visualizar uma informação de que não foram encontrados empreendimentos$/) do
  expect(page).to have_content "Nenhum empreendimento encontrado"
end

Then(/^devo visualizar o campo e o botão de pesquisa$/) do
  expect(page).to have_selector("#search")
  expect(page).to have_selector("#search-button")
end

Then(/^devo ver uma mensagem de empreendimento atualizado com sucesso$/) do
  expect(page).to have_content "Empreendimento atualizado com sucesso."
end

Then(/^devo visualizar o empreendimento atualizado$/) do
  expect(page).to have_content "New Project Name"
end

Then(/^devo ver uma mensagem de empreendimento excluído com sucesso$/) do
  expect(page).to have_content "Empreendimento excluído com sucesso."
end
