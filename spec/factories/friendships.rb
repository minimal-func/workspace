FactoryBot.define do
  factory :friendship do
    association :requester, factory: :user
    association :addressee, factory: :user
    status { "pending" }
  end
end
