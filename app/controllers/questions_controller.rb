class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :find_question, only: [:show, :edit, :update, :destroy]
  before_action :check_author, only: [:edit, :destroy]
  def index
    @questions = Question.all
  end

  def show
    @answers = @question.answers
  end

  def new
    @question = current_user.questions.new
    @question.attachments.build
  end

  def edit

  end

  def create
    @question = current_user.questions.new(question_params)
      if @question.save
        redirect_to question_path(@question),
          notice: "You question successfully created."
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

  private
      def find_question
        @question = Question.find(params[:id])
      end
      def question_params
        params.require(:question).permit(:title, :body, attachments_attributes: [:file])
      end
      def check_author
        redirect_to :back,
          notice: 'You not author' unless @question.user == current_user
      end
end
