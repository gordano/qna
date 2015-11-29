class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :create
  before_action :find_question, only: [:new,:create,:destroy, :update, :isbest]
  before_action :find_answer, only: [:destroy, :update, :isbest]
  before_action :check_author, only: [:destroy, :update]
  def new
    @answer = @question.answers.new
  end

  def create
    if user_signed_in?
      @answer = @question.answers.new(answer_params)
      @answer.user = current_user
      @answer.save
    else
      flash[:notice] = 'Please login to Add Comments'
      flash.keep(:notice)
      render js: "window.location.pathname = '#{new_user_session_path}'"

    end
  end

  def update
    @answer.update(answer_params)
  end

  def destroy
    if @answer.destroy
      #redirect_to question_path(@question),
      #            notice: 'Your Answer was deleted'
    end
  end

  def make_best
    @answer.make_best if @question.user_id == current_user.id
  end

  private
      def answer_params
        params.require(:answer).permit(:body)
      end
      def find_answer
        @answer = Answer.find(params[:id])
      end
      def find_question
        @question = Question.find(params[:question_id])
      end
      def check_author
        redirect_to :back,
          notice: 'You not author' unless @answer.user == current_user
      end
end
