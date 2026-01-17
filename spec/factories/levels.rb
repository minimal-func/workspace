FactoryBot.define do
  factory :level do
    sequence(:level_number) { |n| n }
    sequence(:points_required) { |n| (n - 1) * 100 }
    sequence(:name) { |n| "Level #{n}" }
  end
end
