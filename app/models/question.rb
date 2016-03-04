class Question < ActiveRecord::Base
  include Voteable

	has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  belongs_to :user

  scope :last_day_questions, -> { where(created_at: 1.day.ago.all_day) }

  validates :title, :body, :user_id, presence: true

  accepts_nested_attributes_for :attachments,
          reject_if: proc{ |param| param[:file].blank? },
          allow_destroy: true

  scope :created_yesterday, -> { where(created_at: Time.current.yesterday.all_day) }
end
