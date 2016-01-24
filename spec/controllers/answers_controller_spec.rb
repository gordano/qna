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
  describe 'POST #vote_plus' do
    let!(:other_user) {create(:user)}
    context 'Authorized user' do

      let!(:answer) { create :answer, question: question, user: @user }
      let!(:other_answer) { create :answer, question: question, user: other_user }

      it 'can vote for other_answer' do
        expect { post :vote_plus, question_id: question, id: other_answer }.to change(other_answer.votes, :count)
      end

      it 'and other_answer has votes sum' do
        post :vote_plus, question_id: question, id: other_answer
        expect(other_answer.votes_calc).to eq 1
      end

      it 'but he cant vote twice' do
        create :vote, voteable: other_answer, user: @user
        post :vote_plus, question_id: question, id: other_answer
        expect(other_answer.votes_calc).to eq 1
      end

      it 'cant vote for own answer' do
        expect { post :vote_plus, question_id: question, id: answer }.to_not change(answer.votes, :count)
      end
    end
  end
  describe 'POST #vote_minus' do
    let!(:other_user) {create(:user)}
    context 'Authorized user' do
      let!(:answer) { create :answer, question: question, user: @user }
      let!(:other_answer) { create :answer, question: question, user: other_user }

      it 'can vote for other_answer' do
        expect { post :vote_minus, question_id: question, id: other_answer }.to change(other_answer.votes, :count)
      end

      it 'and other_answer has votes sum' do
        post :vote_minus, question_id: question, id: other_answer
        expect(other_answer.votes_calc).to eq -1
      end

      it 'but he cant vote twice' do
        create :vote, voteable: other_answer, user: @user
        post :vote_minus, question_id: question, id: other_answer
        expect(other_answer.votes_calc).to eq -1
      end

      it 'cant vote for his answer' do
        expect { post :vote_minus, question_id: question, id: answer }.to_not change(Vote, :count)
      end
    end
  end
  describe 'POST #devote' do
    let!(:other_user) {create(:user)}
    context 'Authorized user' do
      let!(:answer) { create :answer, question: question, user: @user }
      let!(:other_answer) { create :answer, question: question, user: other_user }
      let!(:vote) { create :vote, voteable: answer, user: @user}

      it 'can devote for answer with his vote' do
        expect { post :devote, question_id: question, id: answer }.to change(answer.votes, :count)
      end

      it 'and answer has zero votes sum' do
        post :devote, question_id: question, id: answer

        expect(answer.votes_calc).to eq 0
      end

      it 'and then vote one more time' do
        #post :devote, question_id: question, id: answer
        post :vote_plus, question_id: question, id: other_answer
        expect(other_answer.votes_calc).to eq 1
      end

      it 'cant devote for answer without his vote' do
        expect { post :devote, question_id: question, id: other_answer }.to_not change(Vote, :count)
      end
    end
  end
end
