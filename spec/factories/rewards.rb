FactoryBot.define do
  sequence :reward_title do |n|
    "RewardTitle#{n}"
  end

  factory :reward do
    title { :reward_title }
    question
    recipient { nil }
  end
end
