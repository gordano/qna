require_relative 'features_helper'

feature 'Edit answer', %q{
  In order to edit answer
  As authenticated user
  I want to be able to edit my answer
} do
  given!(:user){create(:user)}
  given!(:other_user){create(:user)}
  given!(:question){create(:question, user:user)}
  given!(:answer){create(:answer, question: question, user: user)}
  given!(:other_answer){create(:answer, question: question, user: other_user)}

  describe 'Authenticated user' do
    scenario "try to edit own answer" do
      sign_in(user)
      visit question_path(question)
      expect(page).to have_content 'Edit My Answer'
    end
    scenario "try to edit someone else's answer" do
      sign_in(other_user)
      visit question_path(question)
      within (".answer-box-id-#{answer.id}") do
        expect(page).to_not have_content 'Edit My Answer'
      end
    end
  end
  scenario 'Non-Authenticated user try to edit answer' do
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_content 'Edit My Answer'
    end
  end
end
