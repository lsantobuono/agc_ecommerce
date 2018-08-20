FactoryGirl.define do
  factory :taxon, class: Spree::Taxon do
    name { Faker::Lorem.word }
  end
end
