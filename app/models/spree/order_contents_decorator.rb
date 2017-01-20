module Spree
  OrderContents.class_eval do



    def filter_order_items(params)
      filtered_params = params.symbolize_keys
      return filtered_params if filtered_params[:line_items_attributes].nil? || filtered_params[:line_items_attributes][:id]

      line_item_ids = order.line_items.pluck(:id)

      params[:line_items_attributes].each_pair do |id, value|
        unless line_item_ids.include?(value[:id].to_i) || value[:variant_id].present?
          filtered_params[:line_items_attributes].delete(id)
        end
      end
      filtered_params
    end

  end
end
