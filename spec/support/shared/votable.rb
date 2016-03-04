shared_examples_for 'Votable' do |subject|
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before { sign_in user }

  describe 'patch #vote_plus' do
    it "can vote for #{subject}" do
      expect { patch :vote_plus, id: object_second, format: :json }.to change(object_second.votes, :count)
      expect(object_second.votes_calc).to eq 1
    end

    it "vote for yours #{subject}" do
      expect { patch :vote_plus, id: object, format: :json }.to_not change(object.votes, :count)
    end
  end

  describe 'patch #vote_down' do
    it "can vote for #{subject}" do
      expect { patch :vote_down, id: object_second, format: :json }.to change(object_second.votes, :count)
      expect(object_second.votes_calc).to eq -1
    end

    it "vote for yours #{subject}" do
      expect { patch :vote_down, id: object, format: :json }.to_not change(object.votes, :count)
    end
  end

  describe 'patch #vote_reset' do
    it "can reset votes for #{subject}" do
      patch :vote_plus, id: object_second, format: :json
      expect { patch :vote_reset, id: object_second, format: :json }.to change(object_second.votes, :count)
      expect(object_second.votes_calc).to eq 0
    end
  end
end
