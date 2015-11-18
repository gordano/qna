class AnswersController < ApplicationController
	before_action :find_question, only: [:new,:create,:destroy]
	def new      
      @answer = Answer.new
	end

	def create	  	
	  @answer = Answer.new(answer_params)  	
	  if @answer.save    
	    redirect_to question_path(@question)
	  else	    
	    render :new
	  end
	end

	def destroy      
      @answer = Answer.find(params[:id])
      if @answer.destroy
        redirect_to question_path(@question)
      end
    end

	private
			def answer_params
              params.require(:answer).permit(:body, :question_id)
			end

			def find_question
			  @question = Question.find(params[:question_id])
			end			
end
