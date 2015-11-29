require_relative 'features_helper'

feature 'make_best answer' do

  given!(:current_user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:other_user1) { create(:user) }
  given!(:question) { create(:question, user: current_user) }
  given!(:answer) { create(:answer, question: question, user: current_user) }
  given!(:other_answer) { create(:answer, question: question, user: other_user) }
  given!(:other_answer1) { create(:answer, question: question, user: other_user1) }


  scenario 'guest tries make_best answer' do
    visit question_path(question)
    expect(page).to have_content answer.body
    expect(page).to_not have_selector(:link_or_button, 'Check as best Answer')
  end

  scenario 'not owner question tries make_best answer' do
    sign_in(other_user)
    visit question_path(question)
    expect(page).to have_content answer.body
    expect(page).to_not have_selector(:link_or_button, 'Best Answer')
  end

  scenario 'owner question choose make_best answer', js: true do
    sign_in(current_user)
    visit question_path(question)
    expect(page).to have_content answer.body
    within ".answer-box-id-#{answer.id}" do
      click_on 'Check as best Answer'
      expect(page).to have_content 'Best Answer'
    end
  end

  scenario "best answer seen first", js: true do
    sign_in(current_user)
    visit question_path(question)
    expect(page).to have_content other_answer.body


    expect(answer.body).to have_content first(".answer-body").text
    expect(other_answer.body).to_not have_content first(".answer-body").text

    #save_and_open_page
    page.find(".best-answer-#{other_answer.id}").click
    sleep(2)
    expect(other_answer.body).to have_content first(".answer-body").text
    expect(answer.body).to_not have_content first(".answer-body").text
  end

end
