module Spree::Admin
  class TaxonVideoController < ResourceController

    def model_class
      Spree::Video
    end

    def index
    end

    def create
      v=Spree::Video.new
    end

  end
end
