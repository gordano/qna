module Voteable
    extend ActiveSupport::Concern

    included do
        has_many :votes, as: :voteable, dependent: :destroy
    end

    def get_vote_value(user)
        votes.find_by(user_id: user).value
    end

    def votes_calc
        votes.sum(:value)
    end

    def exists?(user)
       votes.where(user_id: user).exists?
    end

    def devote(user)
        vote = votes.find_by(user_id: user)
        if vote
            vote.destroy
            return true
        end
        false
    end

    def vote(value, user)
        vote = votes.find_or_create_by(user: user)
        vote.update(value: value) if vote.value != value
    end
end
