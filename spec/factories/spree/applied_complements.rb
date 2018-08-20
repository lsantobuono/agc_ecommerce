FactoryGirl.define do
  factory :applied_complement do
    complement
    taxon
    quantity { rand(1..20) }
  end
end
