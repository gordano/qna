require 'rails_helper'

feature 'Delete question', %q{
  In order to delete wrong question
  As authenticated user
  I want to be able to delete question
}do
  given!(:user) { create(:user)}
  given!(:user_other) { create(:user)}
  given!(:question){create(:question, user: user)}

  scenario 'Authenticated user try to revome question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete'
    expect(page).to have_content 'Your Question was deleted'
  end
  scenario 'NON-authenticated user try to revome question and answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Remove My Answer'
    expect(page).to_not have_content 'Delete'
  end
  scenario 'Other user try to revome question' do
    sign_in(user_other)
    visit question_path(question)
    expect(page).to_not have_content 'Delete'
  end

end
