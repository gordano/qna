require_relative 'features_helper'

feature 'Attach file to answer', %q{
  In order to community help
  As authenticated user
  I want to be able to attach files to answer
}do
  given(:user) {create(:user)}
  given(:question){create(:question, user:user)}
  scenario 'Authenticated user create answer', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'Your answer text:' , with: 'test body'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Add answer'
    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_link 'spec_helper.rb'
    end
  end
end
