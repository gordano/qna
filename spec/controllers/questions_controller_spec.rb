require 'rails_helper'

RSpec.describe QuestionsController, :type => :controller do
  let(:user) {create(:user)}
  let(:question) {create(:question, user: user)}
  describe 'GET #index' do
    let(:questions) {create_list(:question, 2)}
    before { get :index }
      it 'populates an array of all questions' do
        expect(assigns(:questions)).to match_array(questions)
      end
      it 'renders index view' do
        expect(response).to render_template :index
      end
  end

  describe 'GET #show' do
    before { get :show, id: question}
    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end
    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }
    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end
    it 'render new view' do
      expect(response).to render_template :new
    end

  end

  describe 'GET #edit' do
    sign_in_user
    let(:question) {create(:question, user: @user)}
    before { get :edit, id: question }
    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end
    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saved the new question in database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end
      it 'redirected to  show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
    context 'with invalid attributes' do
      it 'not saved new question in database' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end
      it 're-renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end

  end
  describe 'PATCH #update' do
    sign_in_user

    context 'valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(assigns(:question)).to eq question
      end
      it 'change question attributes' do
        patch :update, id: question, question: {title: 'new title', body: 'new body'}
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end
      it 'redirected to updated question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(response).to redirect_to question
      end
    end
    context 'invalid attributes' do
      before {patch :update, id: question, question: {title: 'new title', body: nil}}
      it 'not change question attributes' do
        question.reload
        #expect(question.title).to eq 'new title'
        #expect(question.body).to eq 'new body'
        expect(assigns(:question)).to eq question
      end
      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end
  describe 'DELETE #destroy' do
    sign_in_user
    let(:question) {create(:question, user: @user)}
    before { question }
    it 'deleted question' do
      expect { delete :destroy, id: question}.to change(Question, :count).by(-1)
    end
    it 'redirect to index view' do
      delete :destroy, id: question
      expect(response).to redirect_to questions_path
    end
  end
  describe 'POST #vote_plus' do
    let!(:other_user) {create(:user)}
    context 'Authorized user' do
      sign_in_user
      let!(:question) { create :question, user: @user }
      let!(:other_question) { create :question, user: other_user }

      it 'can vote for other_question' do
        expect { post :vote_plus, id: other_question }.to change(other_question.votes, :count)
      end

      it 'and other_question has votes sum' do
        post :vote_plus, id: other_question

        expect(other_question.votes_calc).to eq 1
      end

      it 'but he cant vote twice' do
        create :vote, voteable: other_question, user: @user
        post :vote_plus, id: other_question

        expect(other_question.votes_calc).to eq 1
      end

      it 'cant vote for own question' do
        expect { post :vote_plus, id: question }.to_not change(question.votes, :count)
      end
    end
  end
  describe 'POST #vote_minus' do
    let!(:other_user) {create(:user)}
    context 'Authorized user' do
      sign_in_user
      let!(:question) { create :question, user: @user }
      let!(:other_question) { create :question, user: other_user }

      it 'can vote for question' do
        expect { post :vote_minus, id: other_question }.to change(other_question.votes, :count)
      end

      it 'and other_question has votes sum' do
        post :vote_minus, id: other_question

        expect(other_question.votes_calc).to eq -1
      end

      it 'but he cant vote twice' do
        create :vote, voteable: other_question, user: @user
        post :vote_minus, id: other_question

        expect(other_question.votes_calc).to eq -1
      end

      it 'cant vote for his question' do
        expect { post :vote_minus, id: question }.to_not change(Vote, :count)
      end
    end
  end
  describe 'POST #devote' do
    let!(:other_user) {create(:user)}
    context 'Authorized user' do
      sign_in_user
      let!(:question) { create :question, user: @user }
      let!(:other_question) { create :question, user: other_user }
      let!(:vote) { create :vote, voteable: other_question, user: @user}

      it 'can devote for question with his vote' do
        expect { post :devote, id: other_question }.to change(other_question.votes, :count)
      end

      it 'and question has zero votes sum' do
        post :devote, id: other_question

        expect(other_question.votes_calc).to eq 0
      end

      it 'and then vote one more time' do
        post :devote, id: other_question
        post :vote_plus, id: other_question, user: @user

        expect(other_question.votes_calc).to eq 1
      end

      it 'cant devote for question without his vote' do
        expect { post :devote, id: question }.to_not change(Vote, :count)
      end
    end
  end
end
