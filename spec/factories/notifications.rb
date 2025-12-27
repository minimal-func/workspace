FactoryBot.define do
  factory :notification do
    association :user
    message { "You've earned an achievement!" }
    read_at { nil }
  end
end
