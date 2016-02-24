require_relative 'features_helper'


feature 'Omiauth scenarios' do
  describe 'Sign in Facebook' do
    before { visit new_user_session_path }
    it 'Login with correct credentials' do
      mock_auth_hash(:facebook)
      click_link 'Sign in with Facebook'
      expect(page).to have_content('Successfully authenticated from Facebook account.')
      expect(page).to have_link('Signed Out')
    end
    it 'Login with incorrect credentials' do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      click_link 'Sign in with Facebook'
      expect(page).to have_content('Authentication failed, please try again.')
    end
  end
end
