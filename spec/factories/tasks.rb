FactoryBot.define do
  factory :task do
    content { "Test Task" }
    project
  end
end