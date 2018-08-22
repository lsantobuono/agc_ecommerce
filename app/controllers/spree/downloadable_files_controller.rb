module Spree
  class DownloadableFilesController < Spree::StoreController
    def download
      @downloadable_file = DownloadableFile.find(params[:id])

      type = 'application/pdf'
      
      if (@downloadable_file.file.file.extension == "jpg" || @downloadable_file.file.file.extension == "jpeg")
        type = "image/jpeg"
      end

      if current_spree_user && current_spree_user.confirmed?
        send_file(@downloadable_file.file.path,
          :type => type,
          :disposition => 'attachment',
          :url_based_filename => true)
        return
      end

      redirect_to root_path
    end
  end
end
