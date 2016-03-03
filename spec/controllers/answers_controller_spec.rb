require 'rails_helper'

RSpec.describe AnswersController, :type => :controller do
  sign_in_user
  let(:answer) {create(:answer, question: question, user: @user)}
  let(:question) {create(:question, user: @user)}

  describe 'POST #create' do
    subject { post :create, answer: attributes_for(:answer), question_id: question, format: :js }
    context 'with valid attributes' do

      it 'saved the new answer in database' do
        expect { subject }.to change(@user.answers, :count).by(1)
      end

      it 'answer should be added to question' do
        expect { subject }.to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        subject
        expect(response).to render_template :create
      end
      it_behaves_like 'Publishable', format: :js do
        let(:channel) { "/questions/#{question.id}/answers" }
      end
    end
    context 'with in-valid attributes' do
      subject { post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js }
      it 'not saved the new answer in database' do
        expect { subject }.to_not change(Answer, :count)
      end
      it 'render create template' do

        subject
        expect(response).to render_template :create
      end
    end
  end
  describe 'PATCH #update' do
    subject { patch :update, id: answer, question_id: question, answer: { body: 'new body' }, format: :js }
    before { subject }
    context 'valid attributes' do
      it 'assigned the requested answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end
      it 'change answer attributes' do
        answer.reload
        expect(answer.body).to eq 'new body'

      end

      it 'stand in question page' do
        expect(response).to render_template :update
      end
    end
  end
  describe 'PATCH #destroy' do
    sign_in_user
    before { question; answer}
    it 'delete answer' do
      expect { delete :destroy, id: answer, question_id: question, user_id: @user , format: :js}.to change(Answer, :count).by(-1)
    end
    it 'redirect to question path' do
      expect { delete :destroy, id: answer, question_id: question ,format: :js}.to change(Answer, :count).by(-1)
      expect(response).to render_template :destroy
    end
  end
  describe "PATCH #make_best" do
    sign_in_user
    let!(:answer) {create(:answer, question: question, user: @user)}
    let!(:question) {create(:question, user: @user)}
    let!(:other_user) {create(:user)}
    it "have_http_status(:ok)" do
      patch :makebest, id: answer, question_id: question.id, format: :js
      expect(response).to have_http_status(:ok)
    end

    it "owner question check best answer" do
      #patch :makebest, id: answer, question: question, format: :js
      patch :makebest, id:answer,
                     question_id: question.id,
                     user_id: @user.id,
                     answer: attributes_for(:answer),
                     format: :js

      expect(assigns(:answer).best).to be_truthy
    end

    it "user tried other question check best answer" do
      sign_in(other_user)
      patch :makebest, id:answer,
                     question_id: question.id,
                     user_id: @user.id,
                     answer: attributes_for(:answer),
                     format: :js
      expect(assigns(:answer).best).to be_falsey
    end
  end
  it_behaves_like 'Votable', Answer do
    let(:object) { create(:answer, question: question, user: user) }
    let(:object_second) { create(:answer, question: question, user: other_user) }
  end
end
