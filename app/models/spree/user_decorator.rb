module Spree
  User.class_eval do
		validates :first_name, :last_name, :phone_number, presence: true

		#Esto evite que devise envie mail de confirmacion, la unica forma de confirmacion es la manual del admin
		def send_on_create_confirmation_instructions
        end

  end
end