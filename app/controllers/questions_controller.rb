class QuestionsController < ApplicationController
  include VoteableController

  before_action :authenticate_user!, except: [:show, :index]
  before_action :find_question, only: [:show, :edit, :update, :destroy]
  before_action :check_author, only: [:edit, :destroy]
  def index
    @questions = Question.all
  end

  def show
    @answers = @question.answers.build
    @answers.attachments.build

  end

  def new
    @question = current_user.questions.new
    @question.attachments.build
  end

  def edit
    @question.attachments.build unless @question.attachments.any?
  end

  def create
    @question = current_user.questions.new(question_params)
    @question.save
    if @question.save
      flash[:notice] = 'You question successfully created.'
      publish
      redirect_to @question
    else
      render :new
    end

  end

  def update
    if @question.update(question_params)
      redirect_to @question,
        notice: "You question successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path,
      notice: 'Your Question was deleted'
  end
  def publish
    PrivatePub.publish_to "/questions",
                          question: @question.to_json,
                          author: @question.user.email.to_json
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
          notice: 'You not author' unless @question.user == current_user
      end
end
