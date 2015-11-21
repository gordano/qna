require 'rails_helper'

feature 'User sign out', %q{
  In order to be able to logout
  As an User
  I want to be able to sign out
} do
  given(:user){create(:user)}

  scenario 'Registered user try to sign out' do
    sign_in(user)
    click_on 'Signed Out'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
  scenario 'Non-registered user try to sign out' do
    visit root_path
    expect(page).to_not have_content 'Signed Out'
  end
end
