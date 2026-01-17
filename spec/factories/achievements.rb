FactoryBot.define do
  factory :achievement do
    sequence(:name) { |n| "Achievement #{n}" }
    description { "Example achievement description" }
    points_required { 0 }
    threshold { 1 }
    achievement_type { "points" }
  end
end
