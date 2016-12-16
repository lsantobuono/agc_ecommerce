module Spree
  Product.class_eval do
      default_scope { order("spree_products.position ASC") }

      acts_as_list
  end
end