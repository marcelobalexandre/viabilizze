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

  def new_multiple_units
    @new_multiple_units = FactoryGirl.attributes_for(:multiple_units)
  end

  def register_new_multiple_units(project)
    visit "/pt-BR/users/#{project.user.id}/projects/#{project.id}"
    
    click_link "Adicionar Múltiplas Unidades"
    
    fill_in "multiple_units_quantity",     with: @new_multiple_units[:quantity]
    fill_in "multiple_units_name",         with: @new_multiple_units[:name]
    fill_in "multiple_units_private_area", with: @new_multiple_units[:private_area]
    fill_in "multiple_units_common_area",  with: @new_multiple_units[:common_area]
    fill_in "multiple_units_box_area",     with: @new_multiple_units[:box_area]
    
    click_button "Adicionar Múltiplas Unidades"

    @multiple_units = Unit.where("name like ?", "#{@new_multiple_units[:name]}%")
  end
end

World(UnitHelper) if respond_to?(:World)