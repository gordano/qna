class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource

  before_action :set_question, only: [:index, :create]

  #http://localhost:3000/api/v1/questions/125/answers.json?access_token=
  def index
    @answers = @question.answers
    respond_with @answers
  end

  #http://localhost:3000/api/v1/questions/125/answers/248.json?access_token=
  def show
    @answer = Answer.find(params[:id])
    respond_with @answer, serializer: AnswerSerializer::Answer
  end

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_resource_owner))
    respond_with @answer, location: question_path(@question)
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :best)
  end
end
