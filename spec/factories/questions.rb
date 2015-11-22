# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :question do
    sequence(:title) { |n| "Question title #{n}"}
    sequence(:body) { |n| "Question body #{n}"}
    user
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end
