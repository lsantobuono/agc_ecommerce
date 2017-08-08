module Spree
  class CombosController < Spree::StoreController
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
      @combo = Combo.find(params[:combo_id])
      render ("ordenar_combo")
    end
  end
end
