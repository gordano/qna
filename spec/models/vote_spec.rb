require 'rails_helper'

RSpec.describe Vote, :type => :model do
  subject { build(:vote, :question_vote) }
  it { should belong_to :voteable }
  it { should belong_to :user }
  it { should validate_presence_of :user_id }

  it do
    create :vote, :question_vote
    is_expected.to validate_uniqueness_of(:user_id).scoped_to([:voteable_id, :voteable_type])
  end
end
