class Eventuality < ActiveRecord::Base


  belongs_to :spree_store

  validates :message, :type_eventuality, presence: true
end
