module Spree
  Product.class_eval do
    acts_as_list

    self.whitelisted_ransackable_attributes = %w[description name name_unaccented slug discontinue_on]

    ransacker :name_unaccented, type: :string do |parent|
      Arel.sql("unaccent(\"name\")")
    end

    def get_relacionados
      ret = Set.new
      self.taxons.each do |t|
        ret.merge(t.products)
      end
      ret.delete(self)
      ret = ret.to_a.sample(3)
    end


    def all_parents
      ret = Set.new
      ret.merge self.taxons
      self.taxons.each do |t|
        if t.is_a?(Taxon)
          aux = t.parent
          while (aux.is_a? (Taxon))
            ret = ret.add aux
            aux = aux.parent
          end
        end
      end
      return ret
    end
  end
end
