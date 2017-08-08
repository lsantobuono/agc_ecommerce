module Spree
  VolumePrice.class_eval do
    def amount=(amount)
      amount = amount.gsub(",", ".")
      self[:amount] = amount
    end
  end
end



