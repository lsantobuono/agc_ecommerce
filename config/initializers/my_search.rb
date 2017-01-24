module Spree
  class MySearch < Spree::Core::Search::Base   
    def get_products_conditions_for(base_scope, query)
      unless query.blank?
        fields = ["unaccent(spree_products.name)", "spree_products.description", "spree_variants.sku"]
        values = I18n.transliterate(query).split
        where_str = fields.map { |field| Array.new(values.size, "#{field} ILIKE ?").join(' OR ') }.join(' OR ')

        base_scope = base_scope.includes(:variants_including_master)
          .where([where_str, values.map { |value| "%#{value}%" } * (fields.size)].flatten)
      end
      base_scope
    end
  end
end
