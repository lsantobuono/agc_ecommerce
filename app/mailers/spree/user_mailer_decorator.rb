module Spree
  UserMailer.class_eval do

    def registration_notice(user)
      @name=user.first_name
      mail to: user.email, from: from_address, subject: (Spree::Store.current.name || 'agc') + ' - ' + I18n.t(:subject, :scope => [:devise, :mailer, :registration_notice])
    end

  end
end
