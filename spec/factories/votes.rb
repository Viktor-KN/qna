FactoryBot.define do
  factory :vote do
    user
    votable { create(:question) }
    result { 1 }
  end
end
