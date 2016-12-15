module Spree
  Product.class_eval do
      default_scope { order("spree_products.created_at DESC") }
  end
end