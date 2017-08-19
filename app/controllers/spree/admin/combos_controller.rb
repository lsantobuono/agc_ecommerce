module Spree::Admin
  class CombosController < ResourceController
    before_action :set_products

    def model_class
      Combo
    end

    def clone_combo
      ActiveRecord::Base.transaction do
        combo = Combo.find(params[:id])
        index = Combo.where("name LIKE ?", "Clon de #{combo.name}%").count + 1
        cloned = Combo.create!(
          name: "Clon de #{combo.name} #{index}",
          code: "#{combo.code} #{index}",
          description: combo.description,
          image: combo.image,
          hidden: combo.hidden,
          caro: combo.caro,
          category_id: combo.category_id,
        )
        combo.combo_lines.each do |combo_line|
          cloned.combo_lines.create!(
            product_id: combo_line.product_id,
            quantity: combo_line.quantity,
            price: combo_line.price,
            taxon_id: combo_line.taxon_id,
          )
        end
        flash[:success] = "Se ha clonado el combo"
        redirect_to :back
      end
    rescue
      flash[:error] = "Hubo un error al clonar el combo."
      redirect_to :back
    end

    private

    def set_products
      @taxons = Spree::Taxon.all
      @products = Spree::Product.all
    end

    # def combo_params
    #   params.require(:combo).permit(:name, :code)
    # end

    def collection
      return @collection if @collection.present?
      @collection = super

      if request.xhr? && params[:q].present?
        @collection = @collection.includes(:category)
                          .where("combos.name #{LIKE} :search
                                  OR combos.code #{LIKE} :search 
                                  OR combos.hidden = :search
                                  OR (categories.name #{LIKE} :search AND categories.id = combos.category_id)",
                                { :search => "#{params[:q].strip}%" })
                          .limit(params[:limit] || 100)
        @collection = @collection.order("created_at desc")
      else
        @search = @collection.ransack(params[:q])
        @collection = @search.result.page(params[:page]).per(Spree::Config[:admin_products_per_page])
        @collection = @collection.order("created_at desc") # Intente ordenarlo con ransack pero no pude asi que hago esto 
      end

#      params[:q] ||= {}
#      params[:q][:deleted_at_null] ||= "1"

#      params[:q][:s] ||= "name asc"
#      @collection = Combo.where(nil)
      # Don't delete params[:q][:deleted_at_null] here because it is used in view to check the
      # checkbox for 'q[deleted_at_null]'. This also messed with pagination when deleted_at_null is checked.
      # if params[:q][:deleted_at_null] == '0'
      #   @collection = @collection.with_deleted
      # end
      # @search needs to be defined as this is passed to search_form_for
      # Temporarily remove params[:q][:deleted_at_null] from params[:q] to ransack products.
      # This is to include all products and not just deleted products.
#      @search = @collection.ransack(params[:q].reject { |k, _v| k.to_s == 'deleted_at_null' })
#      @collection = @search.result.
#            page(params[:page]).
#            per(params[:per_page] || Spree::Config[:admin_products_per_page])
#      @collection
    end
  end
end
