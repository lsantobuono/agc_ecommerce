module Spree::Admin
  class CombosController < ResourceController
    before_action :set_products

    def model_class
      Combo
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
