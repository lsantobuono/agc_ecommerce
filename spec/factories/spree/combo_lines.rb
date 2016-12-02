FactoryGirl.define do
  factory :combo_line do
    product
    quantity { rand(1..10) }
  end
end
