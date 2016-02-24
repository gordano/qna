class Authorization < ActiveRecord::Base
  belongs_to :user

  validates :user_id, :provider, :uid, presence: true
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  def self.find_for_oauth(auth)
    find_or_create_by(uid: auth.uid, provider: auth.provider)
  end

end
