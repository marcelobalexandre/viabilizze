FactoryGirl.define do
  factory :unit do
    sequence(:name) { |n| "Unit #{n}" }

    private_area 10
    common_area  10
    box_area     10
    exchanged    false

    association :project
  end
end