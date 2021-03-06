module ParserComboCompuesto

  def parsear_combo_compuestos(string)
    ret = []
    string.downcase.split("-").each do |c|
      cantidad_combo = 1
      string_combo = c

      #si el primer char es un integer, significa que viene con cantidad
      first_char = c[0]

      if first_char.match(/\A-?\d+\Z/).present?
        cantidad_combo = c[/\d+/]
        string_combo = c.sub(cantidad_combo,'')
      end

      combo = Combo.where('lower(code) = ?', string_combo).first
      if (combo.nil?)
        return false,"El id de combo '#{c}' es inválido, por favor chequee que sea correcto, o comuniquese con nosotros."
      else
        ret.push({ random_id: rand(1000000000000), combo: combo, quantity: cantidad_combo.to_i})
      end
    end
    return true,ret
  end

end