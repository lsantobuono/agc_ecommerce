module Spree
	OrderMailer.class_eval do 

		def custom_confirm_email(order, resend = false)
  		@order = order.respond_to?(:id) ? order : Spree::Order.find(order)
      if (@order.email != nil && @order.email != "")
        subject = (resend ? "[#{Spree.t(:resend).upcase}] " : '')
       	subject += "#{Spree::Store.current.name} #{Spree.t('order_mailer.confirm_email.subject')} ##{@order.number}"
  			mail(to: @order.email, from: from_address, subject: subject)
      end
		end

    def confirm_email(order, resend = false)
      @order = order.respond_to?(:id) ? order : Spree::Order.find(order)

      filename = find_pdf_order(@order.number)
      if (filename != nil && filename != "")
        invoice = File.read filename
        attachments["Presupuesto-#{@order.number}.pdf"] = {
          mime_type: 'application/pdf',
          content: invoice
        }
      end

      subject = (resend ? "[#{Spree.t(:resend).upcase}] " : '')
      subject += "#{Spree::Store.current.name} #{Spree.t('order_mailer.presupuesto_email.subject')} ##{@order.number}"
      if (@order.email != nil && @order.email != "")
        mail(to: @order.email, from: from_address, subject: subject)
      end
    end

    private 
    
      require 'find'

      def find_pdf_order (number)
        pdf_file_paths = []
        Find.find('tmp/order_prints') do |path| # Busco en order prints los pdf que correspondan al numero, en un caso normal solo habria 1
          pdf_file_paths << path if path =~ /.*#{number}\.pdf$/
        end
        pdf_file_paths.last # Si la orden fue cambiada por el admin va a haber mas de 1 pdf, y como siempre se ordenan x id creciente, sacar el ultimo me da el mas reciente.
      end
	end
end