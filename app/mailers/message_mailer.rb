class MessageMailer < ActionMailer::Base
  # use your own email address here
  default :to => "info@agc.com.ar"

  def message_me(msg)
    @msg = msg

    mail from: @msg.email, subject: @msg.subject
  end
end
