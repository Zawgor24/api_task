FactoryBot.define do
  factory :post do
    title { Faker::Lorem.word }
    body { Faker::Lorem.word }
  end
end
