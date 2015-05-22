FactoryGirl.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" }

    association :user
  end
end