FactoryBot.define do
  factory :biggest_challenge do
    content
    user

    created_at { DateTime.now }
  end
end
