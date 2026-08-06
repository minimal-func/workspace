FactoryBot.define do
  factory :invitation do
    sequence(:email) { |n| "invitee#{n}@example.com" }
    inviter { association :user }
  end
end
