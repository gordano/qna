require 'rails_helper'

RSpec.describe Answer, :type => :model do
  it { should validate_presence_of :body}
  it { should belong_to :question}
  it { should belong_to :user}
  it { should have_many(:attachments).dependent(:destroy) }
  #it { should accept_nested_attributes_for :attachments }
  it { should have_many(:comments).dependent(:destroy) }

  it_behaves_like 'Attachable'
  it_behaves_like 'Commentable'

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  it 'should notify users' do
    expect(NotifyUsersJob).to receive(:perform_later).with(question)
    Answer.create!(attributes_for(:answer).merge(question: question, user: user))
  end
end
