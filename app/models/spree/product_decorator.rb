module Spree
  Product.class_eval do
      acts_as_list

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