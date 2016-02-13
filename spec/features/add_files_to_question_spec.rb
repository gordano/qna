require_relative 'features_helper'


feature 'Add files to question', %q{
  In order to be add more info to my question
  As an question author
  I want to be able to attach files
} do

  given(:user) { create :user }
  given(:question) { create :question, user: user }
  background do
    sign_in user
  end

  describe 'from new form' do
    before do
      visit new_question_path
    end

    scenario 'User can add files when ask question', js: true do

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Test question body'
      click_on 'Add'
      click_on 'Add'
      all("input[type='file']").first.set("#{Rails.root}/config.ru")
      all("input[type='file']").last.set("#{Rails.root}/Gemfile")
      #save_and_open_page
      click_on 'Create Question'

      expect(page).to have_link 'config.ru'
      expect(page).to have_link 'Gemfile'
    end
  end

  describe 'from edit form' do
    before do
      visit question_path(question)
    end

    scenario 'User can add files when edit his question', js: true do
      click_on "Edit question"
      within '#attachments-question' do
        click_on 'Add'
        all("input[type='file']").first.set("#{Rails.root}/config.ru")
      end
      click_on 'Update Question'

      expect(page).to have_link 'config.ru'
    end
  end
end
