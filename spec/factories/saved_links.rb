FactoryBot.define do
  factory :saved_link do
    title { "Test Saved Link" }
    url { "https://example.com" }
    project
  end
end