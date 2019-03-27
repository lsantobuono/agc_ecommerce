module Spree
   Printables::Order::InvoiceView.class_eval do

        def_delegators :@printable, #Por lo que entiendo, estos son los productos de ordenes accesibles desde el printable
                   :email, # Tuve que agregarle metodo_envio a manopla sino no deja usarlo
                   :bill_address,
                   :ship_address,
                   :tax_address,
                   :item_total,
                   :total,
                   :payments,
                   :shipments,
                   :metodo_envio,
                   :forma_de_pago,
                   :dimensions_and_weight,
                   :metodo_envio_otros,
                   :checkout_notes

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
          total: item.total,
          images: item.variant.images
        )
      end
    end

    private
   end
end
