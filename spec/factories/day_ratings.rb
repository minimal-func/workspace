FactoryBot.define do
  factory :day_rating do
    value { 5 }
    user

    created_at { DateTime.now }
  end
end
