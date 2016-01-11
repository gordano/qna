class Question < ActiveRecord::Base
	has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :user

  validates :title, :body, :user_id, presence: true

  accepts_nested_attributes_for :attachments,
          reject_if: proc{ |param| param[:file].blank? },
          allow_destroy: true
end
