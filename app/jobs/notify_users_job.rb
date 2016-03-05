class NotifyUsersJob < ActiveJob::Base
  queue_as :default

  def perform(answer)
    answer.question.subscriptions.includes(:user).find_each do |s|
      SubscribersMailer.notify(s.user, answer).deliver_later
    end
  end
end
