class SubscribersMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.subscribers_mailer.notify.subject
  #
  def notify(user, answer)
    @answer = answer
    # mail to: user.email, subject: "New answer's notifier"
    mail to: user.email, subject: "New answer to #{answer.question.title}"
  end
end
