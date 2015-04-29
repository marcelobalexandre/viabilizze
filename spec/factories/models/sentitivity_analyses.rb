FactoryGirl.define do
  factory :sensitivity_analysis do
    sequence(:name) { |n| "Sensitivity Analysis #{n}" }

    association :project
  end
end