require_relative 'features_helper'


feature 'Add files to answer', %q{
  In order to be add more info to my answer
  As an answer author
  I want to be able to attach files
} do
  given(:user) { create :user }
  given(:question) { create :question }
  given!(:answer) { create :answer, question: question, user: user }

  background do
    sign_in user
    visit question_path(question)
  end

  describe 'from new form' do
    scenario 'User adds files when save answer', js: true do
      fill_in 'Your answer text:' , with: 'test body'
      click_on 'Add'
      all("input[type='file']").first.set("#{Rails.root}/config.ru")
      all("input[type='file']").last.set("#{Rails.root}/Gemfile")
      click_on 'Add answer'
      within '.answers' do
        expect(page).to have_link 'config.ru'
        expect(page).to have_link 'Gemfile'
      end
    end
  end

  describe 'from edit form' do
    scenario 'User can add files when edit answer', js: true do
      within (".answer-box-id-#{answer.id}") do
        click_on 'Edit My Answer'
        click_on 'Add'
        all("input[type='file']").first.set("#{Rails.root}/config.ru")
        click_on 'Save'
      end
      within ".answer-box-id-#{answer.id}" do
        expect(page).to have_link 'config.ru'
      end
    end
  end
end
