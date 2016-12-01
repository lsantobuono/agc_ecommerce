FactoryGirl.define do
  factory :country, class: Spree::Country do
    iso_name { Faker::Lorem.word }
    iso { Faker::Lorem.word }
    iso3 { Faker::Lorem.word }
    name { Faker::Lorem.word }
    numcode { Faker::Lorem.word }
  end
end
