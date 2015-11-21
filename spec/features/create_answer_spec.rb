require 'rails_helper'

feature 'Create answer', %q{
  In order to community help
  As authenticated user
  I want to be able to write answer
}do
  given(:user) {create(:user)}
  given(:question){create(:question)}
  scenario 'Authenticated user create answer' do
    sign_in(user)
    visit question_path(question)
    click_on 'Add answer'
    fill_in 'Body' , with: 'test body'
    click_on 'Create Answer'
    expect(page).to have_content 'You answer successfully created.'
  end
  scenario 'NON-authenticated user try to create answer' do
    visit question_path(question)
    click_on 'Add answer'
    expect(current_path).to eq new_user_session_path
  end
end
