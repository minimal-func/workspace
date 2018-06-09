FactoryBot.define do
  factory :main_task do
    name
    user

    planned_finish { DateTime.now }
  end
end
