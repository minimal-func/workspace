FactoryBot.define do
  factory :daily_gratitude do
    content { "I am grateful for this test passing" }
    user
  end
end