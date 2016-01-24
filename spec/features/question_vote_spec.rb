require_relative 'features_helper'

feature 'Make question vote', %q{
  In order to make vote
  As authenticated user
  I want to be able to make vote
  and remove vote
}do
    given(:user) {create(:user)}
    given(:other_user) {create(:user)}
    given(:question){create(:question, user:user)}
    scenario 'Make vote +1', js: true do
      sign_in(other_user)
      visit question_path(question)
      within ".question .votes_block" do
        click_on '+'
        expect(page).to have_link 'Your vote: 1, remove vote?'
      end
    end
    scenario 'Make vote -1', js: true do
      sign_in(other_user)
      visit question_path(question)
      within ".question .votes_block" do
        click_on '-'
        expect(page).to have_link 'Your vote: -1, remove vote?'
      end
    end
    scenario 'Remove vote', js: true do
      sign_in(other_user)
      visit question_path(question)
      within ".question .votes_block" do
        click_on '+'
        click_on 'Your vote: 1, remove vote?'
        expect(page).to have_link '+'
      end
    end
end
