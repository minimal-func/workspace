FactoryBot.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  sequence :name do |n|
    "name#{n}"
  end

  sequence :content do |n|
    "Lorem ipsum #{n}"
  end

  sequence(:password) { "12345678" }
end
