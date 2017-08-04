module Spree
  class CategoriesController < Spree::StoreController
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    helper 'spree/products'

    respond_to :html

    def show
      @category = Category.find(params[:category_id])
      return unless @category
      @combos = @category.combos
    end
  end
end