FactoryGirl.define do
  factory :multiple_units do
    sequence(:name) { |n| "Multiple Units #{n}" }

    quantity     5
    private_area 10
    common_area  10
    box_area     10
    exchanged    false
    project_id   1
  end
end