FactoryBot.define do
  factory :daily_lesson do
    content
    user

    created_at { DateTime.now }
  end
end
