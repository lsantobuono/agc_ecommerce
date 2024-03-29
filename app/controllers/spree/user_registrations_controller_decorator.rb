module Spree
  UserRegistrationsController.class_eval do
    def create
      # @order = Spree::Order.find(params[:order_id])
      @user = build_resource(spree_user_params)

      unless verify_recaptcha(model: resource)
        clean_up_passwords(resource)
        render 'spree/combo_order_checkout/registration'
        return
      end

      @on_success_return_to = params[:on_success_return_to]
      resource_saved = resource.save
      yield resource if block_given?
      if resource_saved
        if resource.active_for_authentication?
          set_flash_message :notice, :signed_up
          sign_up(resource_name, resource)
          session[:spree_user_signup] = true
          if @on_success_return_to.present?
            # Si es el checkout de combos
            return redirect_to @on_success_return_to
          end
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords(resource)
        render 'spree/combo_order_checkout/registration'
      end
    end
  end
end
