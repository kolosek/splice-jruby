FactoryGirl.define do
  factory :profile do
    sequence(:profile_name) { |n| "userProfile-#{n}" }
    views 0
  end
end
