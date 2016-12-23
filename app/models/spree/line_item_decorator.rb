module Spree
  LineItem.class_eval do
    belongs_to :combo_aplicado
  end
end
