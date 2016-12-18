FactoryGirl.define do
  factory :task do
    title :task1
    association :list
  end
end
