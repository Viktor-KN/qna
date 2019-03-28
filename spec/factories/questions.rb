FactoryBot.define do
  sequence :title do |n|
    "QuestionTitle#{n}"
  end

  factory :question do
    title
    body { "MyText" }
    author

    trait :invalid do
      title { nil }
    end

    trait :with_files do
      files { [FilesTestHelpers.png, FilesTestHelpers.txt, FilesTestHelpers.zip] }
    end

    factory :question_with_answers do
      transient do
        answers_count { 3 }
        with_answer_files { false }
      end

      after(:create) do |question, evaluator|
        if evaluator.with_answer_files
          create_list(:answer, evaluator.answers_count, :with_files, question: question)
        else
          create_list(:answer, evaluator.answers_count, question: question)
        end
      end
    end
  end
end
