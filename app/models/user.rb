class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :confirmable
  has_many :questions
  has_many :answers
  has_many :comments
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy



  def self.find_for_oauth(auth)
    social_network = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return social_network.user if social_network
    email = auth.info[:email]
    return false if email.nil?
    user = User.find_by(email: email)
    if user
      user.create_social_network(auth)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.create_social_network(auth)
    end

    user
  end

  def create_social_network(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

protected
      def confirmation_required?
        false
      end
end
