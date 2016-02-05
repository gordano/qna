class Answer < ActiveRecord::Base
  include Voteable

	belongs_to :question
  belongs_to :user

  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :body, :question_id, :user_id, presence: true


  accepts_nested_attributes_for :attachments,
            reject_if: proc{ |param| param[:file].blank? },
            allow_destroy: true

  default_scope -> { order(best: :desc).order(created_at: :asc) }
  def make_best
    ActiveRecord::Base.transaction do
      self.question.answers.update_all(best: false)
      raise ActiveRecord::Rollback unless self.update(best: true)
    end
  end
end
