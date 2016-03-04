require "rails_helper"

RSpec.describe SubscribersMailer, type: :mailer do
  describe "notifier" do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:mail) { SubscribersMailer.notify(user, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq "New answer to #{answer.question.title}"
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end
    it "renders the body" do
      expect(mail.body.encoded).to match(answer.body)
    end
  end
end
