require 'rails_helper'

RSpec.describe User, :type => :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password}
  it { should have_many(:comments) }
  it { should have_many(:authorizations)}

  describe '.find_for_oauth' do
      let!(:user) { create(:user) }
      let!(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

      context 'user already has social_network' do
        it 'returns the user' do
          user.authorizations.create(provider: 'facebook', uid: '123456')
          expect(User.find_for_oauth(auth)).to eq user
        end
      end
      context 'user has not social_network' do
        context 'user already exists' do
          let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }
          it 'does not create new user' do
            expect { User.find_for_oauth(auth) }.to_not change(User, :count)
          end
          it 'creates social_network for user' do
            expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
          end
          it 'creates social_network with provider and uid' do
            social_network = User.find_for_oauth(auth).authorizations.first
            expect(social_network.provider).to eq auth.provider
            expect(social_network.uid).to eq auth.uid
          end
          it 'returns the user' do
            expect(User.find_for_oauth(auth)).to eq user
          end
        end
      end
      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' }) }
        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end
        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end
        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end
        it 'creates social_network for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end
        it 'creates social_networks with provider and uid' do
          social_network = User.find_for_oauth(auth).authorizations.first
          expect(social_network.provider).to eq auth.provider
          expect(social_network.uid).to eq auth.uid
        end
      end
    end
end
