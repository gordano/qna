require_relative 'features_helper'

feature 'Attach file to question', %q{
  In order to community help
  As authenticated user
  I want to be able to attach files to question
}do
  given(:user) {create(:user)}
  scenario 'Authenticated user attach file to question' do
    sign_in(user)
    click_on 'New Question'

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test question body'

    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    #save_and_open_page
    click_on 'Create Question'
    expect(page).to have_link 'spec_helper.rb'

  end
end
