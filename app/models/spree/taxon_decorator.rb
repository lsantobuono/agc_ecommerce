module Spree
  Taxon.class_eval do

    has_many :videos, dependent: :destroy

    def all_children
      ret = Set.new
      ret.merge self.products.where("(discontinue_on is null OR discontinue_on > ?) and (deleted_at is null OR deleted_at > ?)", Date.today, Date.today)
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
