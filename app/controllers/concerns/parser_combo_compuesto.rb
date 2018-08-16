module ParserComboCompuesto

  def parsear_combo_compuestos(string)
    ret = []
    string.downcase.split("-").each do |c|
      combo = Combo.where('lower(code) = ?', c).first
      if (combo.nil?)
        return false,"El id de combo '#{c}' es inválido, por favor chequee que sea correcto, o comuniquese con nosotros."
      else
        ret.push(combo)
      end
    end
    return true,ret
  end

end