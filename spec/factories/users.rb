FactoryBot.define do
  factory :user do
    first_name { "Test" }
    last_name  { "User" }
    sequence(:email) { |n| "test.user#{n}@example.com" }
  end
end
