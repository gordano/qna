require 'rails_helper'

RSpec.describe NotifyUsersJob, type: :job do
  let(:user)     { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer)   { create(:answer, question: question, user: user) }

  it 'should send mail with answer to subscribers' do
    question.subscriptions.each do |s|
      expect(SubscribersMailer).to receive(:notify).with(s.user, answer).and_call_original
    end
    NotifyUsersJob.perform_now(answer)
  end
end
