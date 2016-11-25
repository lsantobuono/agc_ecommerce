class MessageMailer < ActionMailer::Base
  # use your own email address here
  default :to => "luciano.santobuono@gmail.com"

  def message_me(msg)
    @msg = msg

    mail from: @msg.email, subject: @msg.subject
  end
end
