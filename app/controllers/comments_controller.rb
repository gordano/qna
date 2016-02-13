class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_resource

  def create
    @comment = @resourse.comments.new(comment_params)
    @comment.user = current_user
    @comment.save

    #if @comment.save
    #  PrivatePub.publish_to "/#{@resourse.class.name.underscore}/#{@resourse.id}/comments", comment: @comment.to_json
    #end
  end

      private

        def comment_params
          params.require(:comment).permit(:body)
        end

        def set_resource
          @resourse = Answer.find(params[:answer_id]) if params[:answer_id]
          @resourse ||= Question.find(params[:question_id])
        end
end
