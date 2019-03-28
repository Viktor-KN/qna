FactoryBot.define do
  sequence :body do |n|
    "AnswerBody#{n}"
  end

  factory :answer do
    body
    question
    author
    best { false }

    trait :invalid do
      body { nil }
    end

    trait :with_files do
      files { [FilesTestHelpers.png, FilesTestHelpers.txt, FilesTestHelpers.zip] }
    end
  end
end
