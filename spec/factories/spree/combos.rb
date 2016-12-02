FactoryGirl.define do
  factory :combo do
    name { Faker::Lorem.word }
    code { Faker::Lorem.word }

    trait :with_lines do
      combo_lines { build_list :combo_line, 5 }
    end
  end
end
