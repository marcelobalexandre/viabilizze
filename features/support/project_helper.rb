module ProjectHelper
  def new_project
    @new_project = FactoryGirl.attributes_for(:project)
  end

  def register_new_project(user)
    visit "/pt-BR/users/#{user.id}/projects/new"
    fill_in "project_name", with: @new_project[:name]
    click_button "Salvar"

    @project = Project.where(name: @new_project[:name]).first
  end
end

World(ProjectHelper) if respond_to?(:World)