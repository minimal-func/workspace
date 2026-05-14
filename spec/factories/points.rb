FactoryBot.define do
  factory :point do
    user
    value { 50 }
    action { "create_project" }
  end
end
