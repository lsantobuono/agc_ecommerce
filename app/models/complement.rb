class Complement < ActiveRecord::Base
  ransacker :name_unaccented, type: :string do |parent|
    Arel.sql("unaccent(\"name\")")
  end
end
