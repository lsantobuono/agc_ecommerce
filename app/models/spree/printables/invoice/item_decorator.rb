module Spree
  Printables::Invoice::Item.class_eval do 
    attr_accessor :bonification
  end
end
