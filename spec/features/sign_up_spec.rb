require_relative 'features_helper'

feature 'User sign up', %q{
  In order to add answers and questions
  As an guest
  I want to be able to sign up
} do
  #given(:user){create(:user)}

  scenario 'Non-Registered user try to sign up' do
    visit new_user_registration_path
    fill_in 'Email', with: 'testtest@test.com'
    fill_in 'Password', with: '123456789'
    fill_in 'Password confirmation', with: '123456789'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end
  scenario 'Registered user try to sign up' do
    visit new_user_registration_path
    expect(page).to_not have_content 'You are already signed in.'
  end
end
