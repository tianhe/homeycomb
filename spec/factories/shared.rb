FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password "password"
    password_confirmation { |u| u.password }
  end

  factory :listing do
    price 1000000
    maintenance 100
    taxes 100
    source { Faker::Internet.domain_name }
    source_id { Faker::Code.isbn }
  end

  factory :user_listing do
    user
    listing
  end
end
