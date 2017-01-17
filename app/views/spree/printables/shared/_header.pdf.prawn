

pdf.move_down 10

pdf.text "#{Spree.t(printable.document_type, scope: :print_invoice)}", align: :center, style: :bold, size: 24

pdf.grid([0,3], [1,4]).bounding_box do
  pdf.move_down 30
  pdf.text Spree.t(:invoice_number, scope: :print_invoice, number: printable.number), align: :right
  pdf.move_down 2
  pdf.text Spree.t(:invoice_date, scope: :print_invoice, date: I18n.l(printable.date)), align: :right
end
