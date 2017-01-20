module Spree
  module Api
    module V1
      LineItemsController.class_eval do 

          def line_items_attributes
            {line_items_attributes: {
                id: params[:id],
                quantity: params[:line_item][:quantity],
                bonification: params[:line_item][:bonification],
                options: line_item_params[:options] || {}
            }}
          end


      end
    end
  end
end
