if order.complementos_para_mostrar.count > 0
  pdf.text "Complementos:", size: 14
  header = [
    pdf.make_cell(content: "Nombre"),
    pdf.make_cell(content: "Cantidad"),
  ]

  data = [header]

  order.complementos_para_mostrar.each do |complemento|
    row = [
      complemento.name,
      complemento.quantity
    ]
    data += [row]
  end

  # column_widths = [0.13, 0.33, 0.2, 0.2, 0.14].map { |w| w * pdf.bounds.width }
  column_widths = [160, 60]
  pdf.table(data, header: true, column_widths: column_widths) do
    row(0).style font_style: :bold
  end
end
