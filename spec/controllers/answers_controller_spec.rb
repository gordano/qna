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

  describe 'PATCH #update' do
    context 'valid attributes' do
      it 'assigned the requested answer to @answer' do
        patch :update, id:answer,
                       question_id: question.id,
                       user_id: @user.id,
                       answer: attributes_for(:answer),
                       format: :js

        expect(assigns(:answer)).to eq answer
      end
      it 'change answer attributes' do
        patch :update, id:answer,
                       question_id: question.id,
                       user_id: @user.id,
                       answer: { body: 'new body'},
                       format: :js
        answer.reload
        expect(answer.body).to eq 'new body'

      end

      it 'stand in question page' do
        patch :update, id:answer,
                       question_id: question.id,
                       user_id: @user.id,
                       answer:  attributes_for(:answer),
                       format: :js
        expect(response).to render_template :update
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
