class AnswersController < ApplicationController
  include VoteableController
  before_action :authenticate_user! ,except: :create
  before_action :find_question, only: [:new,:create,:destroy, :update, :makebest]
  before_action :find_answer, only: [:destroy, :update, :makebest]
  before_action :check_author, only: [:destroy, :update]

  authorize_resource

  def new
    @answer = @question.answers.new
    @answer.attachments.build
  end

  respond_to :js
  def create
    if user_signed_in?
      respond_with @answer = @question.answers.create(answer_params.merge(user: current_user))
    else
      flash[:notice] = 'Please login to Add Comments'
      flash.keep(:notice)
      render js: "window.location.pathname = '#{new_user_session_path}'"
    end
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def destroy
    respond_with @answer.destroy
  end

  def makebest
    @answer.make_best if @question.user_id == current_user.id
  end

  private
      def answer_params
        params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
      end
      def find_answer
        @answer = Answer.find(params[:id])
      end
      def find_question
        @question = Question.find(params[:question_id])
      end
      def check_author
        redirect_to :back,
          notice: 'You not author' unless @answer.user_id == current_user.id
      end
end
