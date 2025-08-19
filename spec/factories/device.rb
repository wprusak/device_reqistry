FactoryBot.define do
  factory :device do
    sequence(:serial_number) { |n| "DEVICE-#{n}" }
    user { nil }
    returned_by_id { nil }
  end
end