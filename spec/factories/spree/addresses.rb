# == Schema Information
#
# Table name: spree_addresses
#
#  id                :integer          not null, primary key
#  firstname         :string
#  lastname          :string
#  address1          :string
#  address2          :string
#  city              :string
#  zipcode           :string
#  phone             :string
#  state_name        :string
#  alternative_phone :string
#  company           :string
#  state_id          :integer
#  country_id        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  dni_cuit          :string
#

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
