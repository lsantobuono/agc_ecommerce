module Spree::Admin
  class CustomizeEmailsController < Spree::Admin::BaseController
    before_action :set_store

    def index
    end

    def update
      current_store.update_attributes store_params

      flash[:success] = Spree.t(:successfully_updated, resource: Spree.t(:general_settings))
      redirect_to admin_customize_emails_path
    end

    private

    def store_params
      params.require(:store).permit(:confirm_email_header, :confirm_email_footer)
    end

    def set_store
      @store = current_store
    end
  end
end
