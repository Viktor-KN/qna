FactoryBot.define do
  factory :link do
    name { "Example link" }
    url { "http://example.com" }
    linkable { nil }

    trait :invalid do
      url { "htp://invalidurl" }
    end

    trait :gist do
      name { "Gist" }
      url { "https://gist.github.com/Viktor-KN/f2f20d40f1a1a57d917917aa93016db4" }
    end
  end
end
