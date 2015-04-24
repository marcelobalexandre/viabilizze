class MultipleUnitsCreator
  def create_multiple_units(project, multiple_units)
    multiple_units.names.each do |name|
      unit = project.units.build(name: name,
                                 private_area: multiple_units.private_area,
                                 common_area: multiple_units.common_area,
                                 box_area: multiple_units.box_area,
                                 exchanged: multiple_units.exchanged)
      unit.save
    end
  end
end