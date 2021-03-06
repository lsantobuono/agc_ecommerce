class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def check_for_mobile
    session[:mobile_override] = params[:mobile] if params[:mobile]
    prepare_for_mobile if mobile_device?
  end

  def prepare_for_mobile
    prepend_view_path Rails.root + 'app' + 'views_mobile'
  end

  def mobile_device?
    if session[:mobile_override]
      session[:mobile_override] == "1"
    else
      # Season this regexp to taste. I prefer to treat iPad as non-mobile.
      (request.user_agent =~ /Mobile|webOS/) && (request.user_agent !~ /iPad/)
    end
  end
  helper_method :mobile_device?

  rescue_from Errors::MyRedirectException do |exception|
    flash[:error] = exception.error_message if exception.error_message.present?
    redirect_to exception.path
  end

  def go_back(error_message = nil)
    path = request.env['HTTP_REFERER'].present? ? request.env['HTTP_REFERER'] : spree.root_path
    raise Errors::MyRedirectException.new(path, error_message)
  end

  def default_url_options(options={})
    if Rails.env.production?
      options.merge({ protocol: "https" })
    else
      options
    end
  end
end
