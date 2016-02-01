class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :voteable, polymorphic: true

  validates :value, :user_id, :voteable_id, presence: true
  validates :value, numericality: true
  validates :user_id, uniqueness: { scope: [:voteable_id, :voteable_type]}
end
