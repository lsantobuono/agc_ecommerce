class MercadopagoController < ActionController::Base
  def mercadopago_webhook
    # byebug
    head :ok
  end

  def search_payments
    unless current_spree_user.present?
      return head :ok
    end
    $mp = MercadoPago.new(ENV['MERDACOPAGO_CLIENT_ID'], ENV['MERDACOPAGO_SECRET_KEY'])
    result = $mp.search_payment({external_reference: params[:order_number], limit: 10})
    if result["status"] == '200'
      @payments = result["response"]["results"]
    else
      @error = true
    end
    respond_to :js
  end
end
