require 'rails_helper'

feature 'Create question', %q{
  In order to get answer for community
  As an authenticated user
  I want to be able to ask questions
}do
  given(:user) {create(:user)}
  scenario 'Authenticated user create question' do
    sign_in(user)
    click_on 'Add question'

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test question body'
    click_on 'Create Question'

    expect(page).to have_content 'You question successfully created.'
  end
  scenario 'NON-authenticated user try to create question' do
    visit questions_path
    click_on 'Add question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
