class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :find_question, only: [:show, :edit, :update, :destroy]
  def index
      @questions = Question.all
  end

  def show
    @answers = @question.answers
  end

  def new
      @question = Question.new
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
      if @question.save
        flash[:success] = "You question successfully created."
        redirect_to question_path(@question)
      else
        render :new
      end
  end

  def update
    if @question.update(question_params)
      flash[:success] = "You question successfully updated."
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path
  end

  private
      def find_question
        @question = Question.find(params[:id])
      end
      def question_params
        params.require(:question).permit(:title, :body)
      end
end
