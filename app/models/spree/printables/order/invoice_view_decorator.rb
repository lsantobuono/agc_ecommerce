module Spree
   Printables::Order::InvoiceView.class_eval do
    def firstname
      if (printable.tax_address != nil)
        printable.tax_address.firstname
      end
    end

    def lastname
      if (printable.tax_address != nil)
        printable.tax_address.lastname
      end
    end

    private
   end
end
