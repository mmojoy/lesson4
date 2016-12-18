FactoryGirl.define do
  factory :list do
    title :Default
    association :user
  end
end
