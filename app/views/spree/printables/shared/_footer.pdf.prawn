
im = Rails.application.assets.find_asset(Spree::PrintInvoice::Config[:logo_path])


pdf.repeat(:all) do
  pdf.grid([7,0], [7,2]).bounding_box do
    if im && File.exist?(im.pathname)
      pdf.image im.filename, vposition: :top, height: 40, scale: Spree::PrintInvoice::Config[:logo_scale]
    end
  end
  pdf.grid([7,2], [7,4]).bounding_box do
    pdf.text "Virrey Cisneros 8649 - José León Suarez - Prov. de Bs As.", align: :right, size: 11
    pdf.text "www.agc.com.ar info@agc.com.ar ", align: :right, size: 11
    pdf.text "Tel: +54 9 11 3092-9473", align: :right, size: 11
  end
end

=begin
pdf.repeat(:all) do
  pdf.grid([7,0], [7,4]).bounding_box do

    data  = []
    data << [pdf.make_cell(content: Spree.t(:vat, scope: :print_invoice), colspan: 2, align: :center)]
    data << [pdf.make_cell(content: '', colspan: 2)]
    data << [pdf.make_cell(content: Spree::PrintInvoice::Config[:footer_left],  align: :left),
    pdf.make_cell(content: Spree::PrintInvoice::Config[:footer_right], align: :right)]

    pdf.table(data, position: :center, column_widths: [pdf.bounds.width / 2, pdf.bounds.width / 2]) do
      row(0..2).style borders: []
    end
  end
end
=end