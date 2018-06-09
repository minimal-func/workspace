FactoryBot.define do
  factory :energy_level do
    value 5
    user

    created_at { DateTime.now }
  end
end
