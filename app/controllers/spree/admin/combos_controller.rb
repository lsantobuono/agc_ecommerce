module Spree::Admin
  class CombosController < ResourceController
    def model_class
      Combo
    end

    private

    # def combo_params
    #   params.require(:combo).permit(:name, :code)
    # end

    def collection
      return @collection if @collection.present?
      params[:q] ||= {}
      params[:q][:deleted_at_null] ||= "1"

      params[:q][:s] ||= "name asc"
      @collection = Combo.where(nil)
      # Don't delete params[:q][:deleted_at_null] here because it is used in view to check the
      # checkbox for 'q[deleted_at_null]'. This also messed with pagination when deleted_at_null is checked.
      # if params[:q][:deleted_at_null] == '0'
      #   @collection = @collection.with_deleted
      # end
      # @search needs to be defined as this is passed to search_form_for
      # Temporarily remove params[:q][:deleted_at_null] from params[:q] to ransack products.
      # This is to include all products and not just deleted products.
      @search = @collection.ransack(params[:q].reject { |k, _v| k.to_s == 'deleted_at_null' })
      @collection = @search.result.
            page(params[:page]).
            per(params[:per_page] || Spree::Config[:admin_products_per_page])
      @collection
    end
  end
end
