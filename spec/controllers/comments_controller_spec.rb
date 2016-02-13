require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:answer) {create(:answer, question: question, user: @user)}
  let(:question) {create(:question, user: @user)}
  let(:comment) { create(:comment, user: @user) }

  describe 'POST #create' do
    sign_in_user

    context 'valid comment' do
      it 'assigns new comment to @comment with question' do
        expect do
          post :create, question_id: question, comment: attributes_for(:comment), format: :js
        end.to change(question.comments, :count).by(1)
      end
      it 'assigns new comment to @comment with answer' do
        expect do
          post :create, question_id: question,answer_id: answer, comment: attributes_for(:comment), format: :js
        end.to change(answer.comments, :count).by(1)
      end
      it 'correctly assigns user' do
        expect do
          post :create, question_id: question, comment: attributes_for(:comment), format: :js
        end.to change(@user.comments, :count).by(1)
      end
    end

    context 'invalid comment' do
      sign_in_user
      it 'does not create new comment' do
        expect do
          post :create, question_id: question, comment: {body: nil}, format: :js
        end.to_not change(Comment, :count)
      end
    end
  end
end


