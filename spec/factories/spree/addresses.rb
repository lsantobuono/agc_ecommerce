FactoryGirl.define do
  factory :address, class: Spree::Address do
    firstname { Faker::Lorem.word }
    lastname { Faker::Lorem.word }
    address1 { Faker::Lorem.word }
    address2 { Faker::Lorem.word }
    city { Faker::Lorem.word }
    zipcode { Faker::Lorem.word }
    phone { Faker::Lorem.word }
    state_name { Faker::Lorem.word }
    alternative_phone { Faker::Lorem.word }
    company { Faker::Lorem.word }
    country
  end
end
