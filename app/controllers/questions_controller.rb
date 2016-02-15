class QuestionsController < ApplicationController
  include VoteableController

  before_action :authenticate_user!, except: [:show, :index]
  before_action :find_question, only: [:show, :edit, :update, :destroy]
  before_action :check_author, only: [:edit, :destroy]
  before_action :build_answer, only: :show
  before_action :build_attachments, only: [:edit,:show]

  def index
    respond_with @questions = Question.all
  end

  def show
    respond_with @question
  end

  def new
    respond_with @question = Question.new
  end

  def edit
  end

  def create
    respond_with @question = current_user.questions.create(question_params)
  end

  def update
    @question.update question_params
    respond_with @question
  end

  def destroy
    respond_with @question.destroy
  end

  private
      def find_question
        @question = Question.find(params[:id])
      end
      def question_params
        params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
      end
      def check_author
        redirect_to :back,
          notice: 'You not author' unless @question.user_id == current_user.id
      end
      def build_answer
        @answer = @question.answers.build
      end
      def build_attachments
        @attachment = @question.attachments ? @question.attachments.any? : @question.attachments.build
      end
end
