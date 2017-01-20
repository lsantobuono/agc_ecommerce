module Spree
  Printables::Invoice::BaseView.class_eval do

    def shipping_methods
      ret = []
      shipments.each do |s|
        if (s.shipping_method != nil)
          ret.push s.shipping_method.name
        end
      end
      ret
    end

  end
end
