require 'rails_helper'

describe 'Ability' do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }
    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should_not be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other_user) { create :user }
    let(:question) { create :question, user: user }
    let(:foreign_question) { create :question, user: other_user }
    let(:answer) { create :answer, question: question, user: user }
    let(:foreign_answer) { create :answer, question: question, user: other_user }
    let(:attachment) { create(:attachment, attachable: question) }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }

    #Question
    it { should be_able_to :create, Question }
    it { should be_able_to :update, create(:question, user: user), user: user }
    it { should be_able_to :destroy, create(:question, user: user), user: user }
    it { should_not be_able_to :update, create(:question, user: other_user), user: user }
    it { should_not be_able_to :destroy, create(:question, user: other_user), user: user }

    #Answer
    it { should be_able_to :create, Answer }
    it { should be_able_to :update, create(:answer, question: question , user: user), user: user }
    it { should be_able_to :destroy, create(:answer, question: question, user: user), user: user }
    it { should_not be_able_to :update, create(:answer, question: question, user: other_user), user: user }
    it { should_not be_able_to :destroy, create(:answer, question: question, user: other_user), user: user }
    it { should be_able_to :makebest, answer, user: user }

    #Comment
    it { should be_able_to :create, Comment }

    #Attachment
    it { should be_able_to :manage, attachment, user: user }
    it { should_not be_able_to :manage, create(:attachment), user: other_user }

    #Vote
    it { should be_able_to :vote, foreign_question, user: user }
    it { should_not be_able_to :vote, question, user: user }
    it { should be_able_to :vote, foreign_answer, user: user }
    it { should_not be_able_to :vote, question, user: user }

  end

  describe 'for admin' do
    let(:user) { create :user, is_admin: true }

    it { should be_able_to :manage, :all }
  end
end
