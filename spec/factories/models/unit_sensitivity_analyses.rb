FactoryGirl.define do
  factory :unit_sensitivity_analysis do
    association :unit
    association :sensitivity_analysis
  end
end