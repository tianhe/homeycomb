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
    size_sqft 1000
    source { Faker::Internet.domain_name }
    source_id { Faker::Code.isbn }
  end

  factory :user_listing do
    user
    listing
    percent_down 20    
  end

  factory :profile do
    user
    percent_down 20
    interest_rate 3.625
    mortgage_years 30
    tax_rate 35
  end

  factory :search_setting do
    user
  end
end
