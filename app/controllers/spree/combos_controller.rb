module Spree
  class CombosController < Spree::StoreController
    def index
    end

    def ordenar_combo
      @combo = Combo.find(params[:combo_id])
      render ("ordenar_combo")
    end
  end
end
