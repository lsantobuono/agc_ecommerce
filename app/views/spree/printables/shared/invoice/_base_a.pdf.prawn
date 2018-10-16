font_style = {
  face: Spree::PrintInvoice::Config[:font_face],
  size: Spree::PrintInvoice::Config[:font_size]
}

order = Spree::Order.find(doc.printable_id)

prawn_document(force_download: true, :margin => [10,10,10,10]) do |pdf|
  pdf.define_grid(columns: 5, rows: 8, gutter: 10)
  pdf.font font_style[:face], size: font_style[:size]


  pdf.move_down 20

  pdf.repeat(:all) do
    render 'spree/printables/shared/header', pdf: pdf, printable: doc
  end

  # CONTENT
  pdf.grid([1,0], [6,4]).bounding_box do

    # address block on first page only
    if pdf.page_number == 1
      render 'spree/printables/shared/address_block_custom', pdf: pdf, printable: doc, type_bill: "Factura A", order: order
    end

    pdf.move_down 10

    render 'spree/printables/shared/invoice/items_a', pdf: pdf, invoice: doc, order: order
    pdf.move_down 10
    render 'spree/printables/shared/invoice/complementos', pdf: pdf, invoice: doc, order: order
    pdf.move_down 10
    pdf.text "PRESUPUESTO VÁLIDO POR 10 DÍAS", size: 14
    pdf.move_down 10

    if (order.ml_user.nil? )
      render 'spree/printables/shared/totals_a', pdf: pdf, invoice: doc, order: order
    end
    
    pdf.move_down 20

    pdf.text Spree::PrintInvoice::Config[:return_message], align: :right, size: font_style[:size]
  end

  # Footer
  if Spree::PrintInvoice::Config[:use_footer]
    render 'spree/printables/shared/footer', pdf: pdf
  end

  # Page Number
  if Spree::PrintInvoice::Config[:use_page_numbers]
    render 'spree/printables/shared/page_number', pdf: pdf
  end
end
