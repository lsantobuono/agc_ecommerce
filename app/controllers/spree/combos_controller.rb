module Spree
  class CombosController < Spree::StoreController
    def index
      @combos=Combo.all
    end

    def mercado_libre
    end


    def ordenar_combo
      @combo = Combo.find(params[:combo_id])
      render ("ordenar_combo")
    end
  end
end
