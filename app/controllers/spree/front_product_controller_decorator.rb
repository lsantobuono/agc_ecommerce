module Spree
  ProductsController.class_eval do
    before_action do
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
