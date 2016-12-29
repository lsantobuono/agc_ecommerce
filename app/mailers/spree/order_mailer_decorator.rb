module Spree
	OrderMailer.class_eval do 

		def custom_confirm_email(order, resend = false)
			@order = order.respond_to?(:id) ? order : Spree::Order.find(order)
      		subject = (resend ? "[#{Spree.t(:resend).upcase}] " : '')
     		subject += "#{Spree::Store.current.name} #{Spree.t('order_mailer.confirm_email.subject')} ##{@order.number}"
			mail(to: @order.email, from: from_address, subject: subject)
		end

    def confirm_email(order, resend = false, custom_text= "")
      @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
      @custom_text = custom_text

      subject = (resend ? "[#{Spree.t(:resend).upcase}] " : '')
      subject += "#{Spree::Store.current.name} #{Spree.t('order_mailer.confirm_email.subject')} ##{@order.number}"
      mail(to: @order.email, from: from_address, subject: subject)
    end

	end
end