# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :attachment do
    file File.open(File.join(Rails.root, 'spec/rails_helper.rb'))
  end
end
