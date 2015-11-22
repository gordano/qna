require 'rails_helper'

feature 'Delete answer', %q{
  In order to delete wrong answer
  As authenticated user
  I want to be able to delete answer
}do
  given!(:user) { create(:user)}
  given!(:user_other) { create(:user)}
  given!(:question) do
    create(:question){|question| user.questions.create(attributes_for(:question))}
  end
  given!(:answer){ create(:answer, question: question, user: user)}


  scenario 'Authenticated user try to revome answer' do
    sign_in(user)
    visit question_path(question)
    click_on 'Remove My Answer'
    expect(page).to have_content 'Your Answer was deleted'
  end
  scenario 'NON-authenticated user try to revome question and answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Remove My Answer'
    expect(page).to_not have_content 'Delete'
  end
  scenario 'Other user try to revome answer' do
    sign_in(user_other)
    visit question_path(question)
    expect(page).to_not have_content 'Remove My Answer'
  end

end
