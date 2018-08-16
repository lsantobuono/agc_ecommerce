module Spree
  Printables::Invoice::Item.class_eval do 
    attr_accessor :bonification, :images
  end
end
