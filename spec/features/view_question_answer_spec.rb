require 'rails_helper'

feature 'View question and answer', %q{
  In order to get question information
  As guest or user
  I want to be able to see question and answer
}do
  given(:user) { create(:user)}
  given(:answer){ create(:answer)}
  given(:question) do
    create(:question){|question| question.answers.create(attributes_for(:answer))}
  end
  scenario 'Authenticated user try view question and answer' do
    sign_in(user)
    visit question_path(question)
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
end
  scenario 'NON-authenticated user try view question and answer' do
    visit question_path(question)
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
  end
end
