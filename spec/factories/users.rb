FactoryBot.define do
  sequence :email do |n|
    "test_user_#{n}@test.com"
  end
  factory :user do
    email
    password { '12345678' }
    password_confirmation { '12345678' }
  end
end
