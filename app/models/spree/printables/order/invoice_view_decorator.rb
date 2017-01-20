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

    def items
      printable.line_items.map do |item|
        Spree::Printables::Invoice::Item.new(
          sku: item.variant.sku,
          name: item.variant.name,
          options_text: item.variant.options_text,
          price: item.price,
          quantity: item.quantity,
          bonification: item.bonification,
          total: item.total
        )
      end
    end

    private
   end
end
