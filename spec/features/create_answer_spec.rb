require_relative 'features_helper'

feature 'Create answer', %q{
  In order to community help
  As authenticated user
  I want to be able to write answer
}do
  given(:user) {create(:user)}
  given(:question){create(:question, user:user)}
  scenario 'Authenticated user create answer', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body' , with: 'test body'
    click_on 'Add answer'
    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'test body'
    end
  end
  scenario 'NON-authenticated user try to create answer', js: true do
    visit question_path(question)
    click_on 'Add answer'
    expect(page).to have_content 'Log in'
  end
end
