# == Schema Information
#
# Table name: eventualities
#
#  id               :integer          not null, primary key
#  message          :string           not null
#  type_eventuality :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Eventuality < ActiveRecord::Base


  belongs_to :spree_store

  validates :message, :type_eventuality, presence: true
end
