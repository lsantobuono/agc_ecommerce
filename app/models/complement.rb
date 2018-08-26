# == Schema Information
#
# Table name: complements
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Complement < ActiveRecord::Base
  ransacker :name_unaccented, type: :string do |parent|
    Arel.sql("unaccent(\"name\")")
  end
end
