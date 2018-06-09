FactoryBot.define do
  factory :reflection do
    content
    user

    created_at { DateTime.now }
  end
end
