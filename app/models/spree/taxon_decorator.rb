module Spree
  Taxon.class_eval do

    def all_children
      ret = Set.new
      ret.merge self.products 
      self.children.each do |c|
        if c.is_a?(Taxon)
          ret = ret.merge c.products
          ret = ret.merge c.all_children
        end
      end
      return ret
    end

  end
end
