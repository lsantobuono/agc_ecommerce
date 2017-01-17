im = Rails.application.assets_manifest.files.values.map{|v| v['logical_path']}.include?('#{Spree::PrintInvoice::Config[:logo_path]}')
if im && File.exist?(im.pathname)
  pdf.image im.filename, vposition: :top, height: 40, scale: Spree::PrintInvoice::Config[:logo_scale]
end

  pdf.text "       #{Spree.t(printable.document_type, scope: :print_invoice)}", align: :left, style: :bold, size: 18

pdf.grid([0,3], [1,4]).bounding_box do
  pdf.move_down 6
  pdf.text Spree.t(:invoice_date, scope: :print_invoice, date: I18n.l(printable.date)), align: :right
end
