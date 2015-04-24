module UnitHelper
  def new_unit
    @new_unit = FactoryGirl.attributes_for(:unit)    
  end

  def register_new_unit(project)
    visit "/pt-BR/users/#{project.user.id}/projects/#{project.id}"
    
    click_link "Adicionar Unidade"
    
    fill_in "unit_name",         with: @new_unit[:name]
    fill_in "unit_private_area", with: @new_unit[:private_area]
    fill_in "unit_common_area",  with: @new_unit[:common_area]
    fill_in "unit_box_area",     with: @new_unit[:box_area]
    
    click_button "Adicionar"

    @unit = Unit.where(name: @new_unit[:name]).first
  end
end

World(UnitHelper) if respond_to?(:World)