require 'rails_helper'

RSpec.describe AnswersController, :type => :controller do
  sign_in_user
  let(:answer) {create(:answer, question: question, user: @user)}
  let(:question) {create(:question, user: @user)}

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saved the new answer in database' do
          expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js }.to change(question.answers, :count).by(1)
      end
      it 'render create template' do
          post :create, question_id: question, answer: attributes_for(:answer), format: :js
          expect(response).to render_template :create
      end
    end
    context 'with in-valid attributes' do
      it 'not saved the new answer in database' do
        expect { post :create, question_id: question ,answer: attributes_for(:invalid_answer), format: :js }.to_not change(Answer, :count)
      end
      it 'render create template' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #destroy' do
    sign_in_user
    before { question; answer}
    it 'delete answer' do
      expect { delete :destroy, id: answer, question_id: question, user_id: @user }.to change(Answer, :count).by(-1)
    end
    it 'redirect to question path' do
      expect { delete :destroy, id: answer, question_id: question }.to change(Answer, :count).by(-1)
      expect(response).to redirect_to question_path(assigns(:question))
    end
  end
end
