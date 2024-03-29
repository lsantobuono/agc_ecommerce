module Spree
  HomeController.class_eval do
    before_filter :check_for_mobile

    def index
      if (Rails.env == "production")
        @searcher = build_searcher(params.merge(include_images: true).merge(taxon: 59))
      else 
        @searcher = build_searcher(params.merge(include_images: true))
      end  
      @products = @searcher.retrieve_products.order("spree_products.position ASC")
      @products = @products.includes(:possible_promotions) if @products.respond_to?(:includes)
      @taxonomies = Spree::Taxonomy.includes(root: :children)
      
      if (Spree::Store.first.eventuality_id !=nil && Spree::Store.first.eventuality_id != 0 )
        e = Eventuality.find(Spree::Store.first.eventuality_id)
        if (e != nil)
          type = (e.type_eventuality == 0) ? :danger : :info 
          flash.now[type]= e.message
        end
      end
    end

    def contact
    	@message=Message.new
    end

    def about_us
    end

    def help
    end

    def descargas
    end

	def newMessage
    	@message = Message.new
  	end
  
  def createMessage
    @message = Message.new(message_params)
    if verify_recaptcha(model: @message) && @message.valid?
      MessageMailer.message_me(@message).deliver_now
      @message = Message.new
      flash.now[:info] = "Mensaje Enviado. Gracias por contactarnos."
    else
      # flash.now[:error] = "Hubo un error"
      # Se muestran los errores del modelo
    end
    render "spree/home/contact"
  end

    def publicDownload
      fileName= "public/descargas/#{params[:file_id]}.#{params[:format]}"

      type = 'application/pdf'

      if (params[:format] == "jpg" || params[:format] == "jpeg")
        type = "image/jpeg"
      end

      send_file(fileName,
        :type => type,
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
			params.require(:message).permit(:name, :tel,:email, :subject, :content, :enterprise)
		end
  end
end