require_relative 'features_helper'

feature 'View questions', %q{
  In order to view questions list
  As guest or user
  I want to be able to see questions
}do
  given(:user) {create(:user)}
  scenario 'Authenticated user can view questions' do
    sign_in(user)
    visit questions_path
    expect(current_path).to eq questions_path
  end
  scenario 'NON-authenticated user can view questions' do
    visit questions_path
    expect(current_path).to eq questions_path
  end
end
