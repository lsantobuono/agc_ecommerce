module Spree
  class CategoriesController < Spree::StoreController
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    helper 'spree/products'

    respond_to :html

    def show
      @category = Category.find(params[:category_id])
      return unless @category
      @combos = @category.combos

      if (Spree::Store.first.eventuality_id !=nil && Spree::Store.first.eventuality_id != 0 )
        e = Eventuality.find(Spree::Store.first.eventuality_id)
        if (e != nil)
          type = (e.type_eventuality == 0) ? :danger : :info 
          flash.now[type]= e.message
        end
      end
    end
  end
end