module Spree
	module Admin
		ProductsController.class_eval do
			
			before_filter :getProductAndVariants, only: [:indexFile, :newFile, :createFile, :downloadFile, :destroyFile]

			def ordenar_productos
				@collection = Spree::Product.unscoped.where(deleted_at: nil).order(:position)
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

      def collection
        return @collection if @collection.present?

        params[:q] ||= {}
        params[:q][:deleted_at_null] ||= "1"
        params[:q][:discontinue_on_null] ||= "1"
        params[:q][:name_unaccented_or_variants_including_master_sku_cont] ||= ""

        params[:q][:s] ||= "name asc"
        @collection = super
        # Don't delete params[:q][:deleted_at_null] here because it is used in view to check the
        # checkbox for 'q[deleted_at_null]'. This also messed with pagination when deleted_at_null is checked.
        if params[:q][:deleted_at_null] == '0'
          @collection = @collection.with_deleted
        end
        # @search needs to be defined as this is passed to search_form_for
        # Temporarily remove params[:q][:deleted_at_null] from params[:q] to ransack products.
        # This is to include all products and not just deleted products.
        # byebug
        other_params = params.deep_dup
        other_params[:q][:name_unaccented_or_variants_including_master_sku_cont] = I18n.transliterate(other_params[:q][:name_unaccented_or_variants_including_master_sku_cont]).downcase
        @search = @collection.ransack(other_params[:q].reject { |k, _v| k.to_s == 'deleted_at_null' })
        @collection = @search.result.
              distinct_by_product_ids(other_params[:q][:s]).
              includes(product_includes).
              page(params[:page]).
              per(params[:per_page] || Spree::Config[:admin_products_per_page])
        @collection
      end
		end
	end
end