module Spree
	module Admin
		ProductsController.class_eval do
			
			before_filter :getProductAndVariants, only: [:indexFile, :newFile, :createFile, :downloadFile, :destroyFile]

			def ordenar_productos
				@collection = Spree::Product.unscoped.order(:position)
			end

			def getProductAndVariants
				@product = Product.friendly.find(params[:product_id])
				@variants = @product.variants
				@variants = [@product.master] if @variants.empty?
			end

			def getVariant

			end

			def indexFile
				render("spree/admin/files/index")
			end

			def newFile
				render("spree/admin/files/new")
			end

			def createFile
				@variant = @product.variants.find_by(id: params[:variant_id])
				@variant = @product.master if @variant.nil?
				@variant.file = params[:attachment]
				@variant.file_alt = params[:alt]

				if @variant.save
			    	flash.now[:success] = "Archivo Subido!"
					render("spree/admin/files/index")
			    else
			    	flash.now[:error] = "Error en subida - Verificar que el tipo de archivo sea PDF"
					render("spree/admin/files/index")				
			    end
			end

			def downloadFile
				@variant = @product.variants.find_by(id: params[:variant_id])
				@variant = @product.master if @variant.nil?
				send_file(@variant.file.path,
	    		    :type => 'application/pdf',
		     	  	:disposition => 'attachment',
		     	  	:url_based_filename => true)
  			end

			def destroyFile
				@variant = @product.variants.find_by(id: params[:variant_id])
				@variant = @product.master if @variant.nil?
				@variant.remove_file!
				if @variant.save
					flash[:success] = "Archivo eliminado!"
				else
					flash[:error] = "Error en eliminación de archivo"
				end
				render_js_for_destroy
			end
		end
	end
end