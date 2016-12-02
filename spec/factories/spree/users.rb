FactoryGirl.define do
  factory :user, class: Spree::User do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    phone_number { Faker::PhoneNumber.phone_number }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }

    trait :admin do
      spree_roles { [Spree::Role.find_by(name: 'admin') || create(:role, name: 'admin')] }
    end
  end
end
