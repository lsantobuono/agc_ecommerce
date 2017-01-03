module Spree
  User.class_eval do
		validates :first_name, :last_name, :phone_number, presence: true

		#Esto evite que devise envie mail de confirmacion, la unica forma de confirmacion es la manual del admin
    #Y le envia nuestro mail custom de avisarle su user y pass
		def send_on_create_confirmation_instructions
      self.devise_mailer.registration_notice(self).deliver
    end

  end
end