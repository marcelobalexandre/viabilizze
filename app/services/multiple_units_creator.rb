class MultipleUnitsCreator
  def self.call(project, multiple_units)
    multiple_units.names.each do |name|
      unit = project.units.create(name: name,
                                  private_area: multiple_units.private_area,
                                  common_area: multiple_units.common_area,
                                  box_area: multiple_units.box_area,
                                  exchanged: multiple_units.exchanged)
    end
  end
end