module Spree::Admin
  ProductsController.class_eval do
    create.after :create_after

    def location_after_save
      if params[:add_to_order].present?
        return :back
      else
        spree.edit_admin_product_url(@product)
      end
    end

    def create_after
      if params[:add_to_order].present? && @order = Spree::Order.friendly.find(params[:add_to_order])
        @order.contents.add(@product.master, 1)
        @order.next
        @product.deleted_at = Time.zone.now
        @product.save
      end
    end
  end
end
