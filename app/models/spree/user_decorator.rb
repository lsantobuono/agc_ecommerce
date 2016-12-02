module Spree
  User.class_eval do
		validates :first_name, :last_name, :phone_number, presence: true
  end
end