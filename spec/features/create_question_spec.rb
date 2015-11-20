require 'rails_helper'

feature 'Create question', %q{
  In order to get answer for community
  As an authenticated user
  I want to be able to ask questions
}do
  scenario 'Authenticated user create question' do
    User.create!(email: 'user@test.com', password: '12345678' )

    visit new_user_session_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    #visit question_path
    click_on 'Add question'

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test question body'
    click_on 'Create Question'

    expect(page).to have_content 'You question successfully created.'


  end
  scenario 'NON-authenticated user create question' do
    User.create!(email: 'user@test.com', password: '12345678' )

    visit new_user_session_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '1234567899'
    click_on 'Log in'

    expect(page).to have_content 'Invalid email or password. Log in Email Password Remember me Sign up Forgot your password?'
  end
end
