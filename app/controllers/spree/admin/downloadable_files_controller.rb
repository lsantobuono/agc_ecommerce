module Spree::Admin
  class DownloadableFilesController < ResourceController

    def model_class
      DownloadableFile
    end

    private

    def collection
      return @collection if @collection.present?
      @collection = super

      if request.xhr? && params[:q].present?
        @collection = @collection
                        .where("unaccent(downloadable_files.name) #{LIKE} :search",
                               { :search => "#{params[:q].strip}%" })
                        .limit(params[:limit] || 100)
        @collection = @collection.order("created_at desc")
      else
        @search = @collection.ransack(params[:q])
        @collection = @search.result.page(params[:page]).per(Spree::Config[:admin_products_per_page])
        @collection = @collection.order("created_at desc") # Intente ordenarlo con ransack pero no pude asi que hago esto 
      end
    end
  end
end