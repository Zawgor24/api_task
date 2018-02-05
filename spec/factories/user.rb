FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(8) }
    name { Faker::ProgrammingLanguage.name }
  end
end
