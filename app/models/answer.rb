class Answer < ActiveRecord::Base
  include Voteable

	belongs_to :question
  belongs_to :user

  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :body, :question_id, :user_id, presence: true


  after_create :create_subscription_for_author
  after_commit :notify_subscribers

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

  private
    def notify_subscribers
      NotifyUsersJob.perform_later(self)
    end
    def create_subscription_for_author
      Subscription.find_or_initialize_by(user: self.user, question: self.question)
    end

end
