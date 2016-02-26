class ConfirmationMailer < ApplicationMailer
  default from: "admin@example.com",
  template_path: "mailers/confirmations"

  def auth_confirmation()
    mail      to: "noname@test.test",
         subject: "Confirm your email pls"
  end
end
