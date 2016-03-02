class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource

  def index
    #http://localhost:3000/api/v1/questions.json?
    @questions = Question.all
    respond_with @questions #respond_with @questions.to_json(include: :answers)
  end

  def show
    #http://localhost:3000/api/v1/questions/<id>.json?access_token=
    @question = Question.find(params[:id])
    respond_with @question
  end

  def create
    @question = current_resource_owner.questions.create(question_params)
    respond_with @question
  end

  private
    def question_params
      params.require(:question).permit(:title, :body)
    end
end
