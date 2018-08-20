pdf.text "Complementos:", size: 14
order.complementos_para_mostrar.each do |complemento|
  pdf.move_down 10
  pdf.text "Cantidad de #{complemento.name}: #{complemento.quantity}", size: 14
end
