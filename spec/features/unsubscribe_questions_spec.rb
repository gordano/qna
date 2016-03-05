require_relative 'features_helper'

feature 'Subscribe to the question', %q{
  In order to do not receive notifications with a new answer
  As an authenticated user
  I want to be able unsubscribe from the questions
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:subscription) { create(:subscription, question: question, user: user) }

  scenario 'Authenticated user tries to unsubscribe from the question', js: true do
    sign_in(user)

    visit question_path(question)

    click_on 'Unsubscribe'

    within '.subscription' do
      expect(page).to have_link 'Subscribe'
      expect(page).not_to have_link 'Unsubscribe'
    end
  end

end
