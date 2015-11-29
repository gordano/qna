require_relative 'features_helper'

feature 'Edit answer', %q{
  In order to edit answer
  As authenticated user
  I want to be able to edit my answer
} do

  describe 'Authenticated user' do
    scenario "try to edit own answer"
    scenario "try to edit someone else's answer"
  end
  scenario 'Non-Authenticated user try to edit answer'
end
