require_relative 'features_helper'

feature 'Add comment to question', %q{
  In order to discuss
  As user
  I want to be able add comment to question
} do
  given(:user) {create(:user)}
  given(:question){create(:question, user:user)}
  given(:comment) { create(:comment, user:user) }

  scenario 'auth user add comment', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: comment.body
    click_on 'Create question comment'

    expect(page).to have_content comment.body
  end

  scenario 'guest try create question' do
    visit question_path(question)

    expect(page).to_not have_content 'Create question comment'
  end
end
