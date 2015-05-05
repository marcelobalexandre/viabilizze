class UnitSensitivityAnalysesInitializer
  def self.call(sensitivity_analysis)
    if sensitivity_analysis.new_record?
      sensitivity_analysis.project.units.each { |unit| sensitivity_analysis.unit_sensitivity_analyses.build(unit: unit) }
    else
      new_units = sensitivity_analysis.project.units.select do |unit|
        !sensitivity_analysis.unit_sensitivity_analyses.any? { |unit_sensitivity_analysis| unit_sensitivity_analysis.unit == unit }
      end

      new_units.each { |unit| sensitivity_analysis.unit_sensitivity_analyses.build(unit: unit) }
    end
  end
end

