module Spree
  class CombosController < Spree::StoreController
    include ParserComboCompuesto

    def index
      @combos=Combo.all
    end

    def mercado_libre
    end

    def mercado_libre_combo
      @combo = Combo.where('lower(code) = ?', params[:combo_id].downcase).first
      if (@combo == nil)
        flash[:error] = "Se ingresó un enlace inváido"
        redirect_to(spree.root_path)
      end
    end


    def ordenar_combo
      @combos = [Combo.find(params[:combo_id])]
      render :ordenar_combo_compuesto
    end

    def ordenar_combo_compuesto
      correct_string, @combos = parsear_combo_compuestos(params[:combo_string])
    end
  end
end
