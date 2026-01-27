FactoryBot.define do
  factory :crypto_transaction do
    user { nil }
    transaction_hash { "MyString" }
    block_number { 1 }
    block_timestamp { "2025-12-29 11:43:08" }
    from_address { "MyString" }
    to_address { "MyString" }
    value { "9.99" }
    token_symbol { "MyString" }
    token_name { "MyString" }
    token_address { "MyString" }
    transaction_type { "MyString" }
    gas_used { "9.99" }
    gas_price { "9.99" }
  end
end
