FactoryBot.define do
  factory :post do
    title { "Test Post" }
    short_description { "This is a test post" }
    project
  end
end