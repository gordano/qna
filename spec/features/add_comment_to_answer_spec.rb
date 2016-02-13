require_relative 'features_helper'

feature 'Add comment to answer', %Q{
  In order to discuss
  As user
  I want to be able add comment to answer
}do
  given(:user) { create(:user) }
  given(:question){create(:question, user:user)}
  given!(:answer) { create(:answer, question: question, user:user) }
  given(:comment) { create(:comment, user:user) }

  scenario 'auth user add comment', js: true do
    sign_in(user)
    visit question_path(question)
    within ".comment-form.of-answer" do
      fill_in 'Body', with: comment.body
      click_on 'Create answer comment'
    end

    expect(page).to have_content comment.body
  end

  scenario 'guest try create answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_content 'Create answer comment'
    end
  end
end
