module Spree
  HomeController.class_eval do
    def contact
    	@message=Message.new
    end


	def newMessage
    	@message = Message.new
  	end
  
	def createMessage
		@message = Message.new(message_params)
		if @message.valid?
			MessageMailer.message_me(@message).deliver_now
			flash.now[:info] = "Mensaje Enviado. Gracias por contactarnos."
		end
		render "spree/home/contact"
  	end


  	private

		def message_params
			params.require(:message).permit(:name, :tel,:email, :subject, :content)
		end
  end
end