class QuestionsController < ApplicationController
	before_action :find_question, only: [:show, :edit]
	def index
      @questions = Question.all
	end

	def show      
	end

	def new 
      @question = Question.new
	end

	def edit     
	end

	private
			def find_question
			  @question = Question.find(params[:id])
			end 
end
