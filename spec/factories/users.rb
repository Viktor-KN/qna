FactoryBot.define do
  sequence :email do |n|
    "test_user_#{n}@test.com"
  end
  factory :user, aliases: [:author] do
    email
    password { '12345678' }
    password_confirmation { '12345678' }

    factory :user_with_questions do
      transient do
        questions_count { 3 }
      end

      after(:create) do |user, evaluator|
        create_list(:question, evaluator.questions_count, author: user)
      end
    end

    factory :user_with_question_and_answers do
      transient do
        answers_count { 3 }
      end

      after(:create) do |user, evaluator|
        question = create(:question, author: user)
        create_list(:answer, evaluator.answers_count, question: question, author: user)
      end
    end
  end
end
