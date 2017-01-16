module Spree
  HomeController.class_eval do
    def index
      @searcher = build_searcher(params.merge(include_images: true))
      @products = @searcher.retrieve_products.order("spree_products.position ASC")
      @products = @products.includes(:possible_promotions) if @products.respond_to?(:includes)
      @taxonomies = Spree::Taxonomy.includes(root: :children)
      
        flash.now[:danger]= "Nos encontramos con desperfectos en nuestra línea telefónica, comuníquese por favor al: 11-6051-0878"
    end

    def contact
    	@message=Message.new
    end

    def about_us
    end

    def descargas
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

    def publicDownload

      fileName= "public/descargas/#{params[:file_id]}.pdf"

      send_file(fileName,
        :type => 'application/pdf',
        :disposition => 'attachment',
        :url_based_filename => true)
    end

  	#No me puteen soy Giordano. Ya se que es una verga estos metodos aca, pero no tengo idea en que controllers tendrian que ir...
  	# Y crear un nuevo controller de Spree con todas sus pelotudeces es un misterio para mi
  def downloadFile
		@product = Product.friendly.find(params[:product_id])
		@variants = @product.variants
		@variants = [@product.master] if @variants.empty?		
		@variant = @product.variants.find_by(id: params[:variant_id])
		@variant = @product.master if @variant.nil?
		send_file(@variant.file.path,
	    	:type => 'application/pdf',
		    :disposition => 'attachment',
		    :url_based_filename => true)
  end

  	private

		def message_params
			params.require(:message).permit(:name, :tel,:email, :subject, :content)
		end
  end
end